---
title: Testing a Unit of Code
---

This is a common pattern in my old test code.
When I go back and look at my old tests I find this.
This is how I used to write my tests.

```ts
@suite class OperationChainTest {
  @test async "should invoke chain"() {
    const operations: OperationCollection<MockState> = [
      state => Promise.resolve(state.set(INVOCATION_COUNT, state.invocationCount + 1)),
      state => Promise.resolve(state.set(INVOCATION_COUNT, state.invocationCount + 1)),
      state => Promise.resolve(state.set(INVOCATION_COUNT, state.invocationCount + 1)),
    ]
    const result = await operationChain(operations, new MockState())
    expect(result).to.be.instanceof(MockState)
    expect(result.invocationCount).to.equal(3)
  }

  @test async "should forward error to catch block"() {
    const failed = "failed"
    const operationStub = sinon.stub()
    operationStub.resolves({})
    const operations: OperationCollection<MockState> = [
      operationStub as Operation<MockState>,
      state => Promise.reject(failed),
      operationStub as Operation<MockState>,
    ]
    const result = await operationChain(operations, new MockState())
      .catch(error => {
        expect(error).to.equal(failed)
      })
    expect(operationStub.calledOnce).to.be.true
    expect(result).to.be.undefined
  }
}
```

And then something clicked.

I better understood what we mean by a "unit" of code (I was basically confusing integration tests for unit tests.) I better understood _why_ we want one assert per test. I stopped feeling like having _alot_ of super simple test functions was somehow wrong. (Not even sure where I picked that feeling up.) And I better understood that my tests should document my intent for future readers (including myself) when all context on the decisions I am making has been lost.

Now I write the tests you saw above like this.
Now I write my tests like this.

```ts
@suite
class OperationChainFailureTest {
  state: MockState
  error = new Error("failed operation")
  invokedStub: sinon.SinonStub
  errorStub: sinon.SinonStub
  ignoredStub: sinon.SinonStub
  ops: OperationCollection<MockState>
  result: Operation<MockState>

  before() {
    this.state = new MockState()
    this.invokedStub = sinon.stub().resolves({})
    this.errorStub = sinon.stub().rejects(this.error)
    this.ignoredStub = sinon.stub().resolves({})
    this.ops = [
      this.invokedStub as Operation<MockState>,
      this.errorStub as Operation<MockState>,
      this.ignoredStub as Operation<MockState>,
    ]
  }

  @test
  async "should invoke first operation"() {
    await operationChain(this.ops, this.state).catch(() => {})
    expect(this.invokedStub.calledOnce)
  }

  @test
  async "should invoke second operation"() {
    await operationChain(this.ops, this.state).catch(() => {})
    expect(this.errorStub.calledOnce)
  }

  @test
  async "should not invoke third operation"() {
    await operationChain(this.ops, this.state).catch(() => {})
    expect(this.ignoredStub.notCalled)
  }

  @test
  async "should invoke catch with error"() {
    const result = await operationChain(this.ops, this.state).catch(error =>
      expect(error).to.deep.equal(this.error)
    )
  }

  @test
  async "should result in undefined value"() {
    const result = await operationChain(this.ops, this.state).catch(() => {})
    expect(result).to.be.undefined
  }
}
```
