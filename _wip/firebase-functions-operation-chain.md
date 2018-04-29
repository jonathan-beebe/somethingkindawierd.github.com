---
title: A Better Firebase Functions `onRequest` Handler?
---

When writing my first Firebase Cloud Function handler I found myself wanting to test the code. A typical handler in my project will look something like this:

```ts
// index.ts
export default functions.https.onRequest((req, res) => {
  // authorize the user, then
  // process the order, then
  // save the purchase, then
  // handle success response, or
  // handle error response
})
```

I am inexperienced with server-side js. So naturally I consulted the internet. Most of the code samples I find in repos and blog posts show coding right in the body of this function. This makes for succinct sample code. It quickly falls apart when trying to build robust production code.

How can I test all my work within that function?

I could try invoking it directly.

```ts
// index.test.ts
include * as requestHandler from "./index"

describe("trying to test my handler", () => {
  it("should work", async () => {
    const request = mockRequest()
    const response = makeSpy()
    await requestHandler(request, response)
    expect(response.code).equals(200)
  })
})
```

Hmm. How do I shape the mock request? What should it look like for an authorized user? How do I shape the request to represent a purchase? How can I test the handling of a 500 error inside of processing the order? Or what if the payment service I'm integrating fails to respond, how can I verify behavior under that scenario?

With this approach I can already see how relient it will be on mocks. I will need to mock out the request for every scenario I want to test. And I must verify each possible outcome by spying on the response object so I can make sure it sends the correct response for each branch of code. Any third party code such as a payment service will also need to be mocked or stubbed. And on and an. Those sound like integration tests. Not unit tests.

I’ve [read that mocking is a code smell](https://medium.com/javascript-scene/mocking-is-a-code-smell-944a70c90a6a). I’ve heard large functions with more than a single responsibility are bad. Maybe I can do better?

What I really want is an http request handler that looks like this:

```ts
// index.ts
import * as requestHandler from "./requestHandler"
export default functions.https.onRequest(requestHandler)
```

Now I don’t need to include the `functions.https.onRequest` function and everything that comes with it. I can focus soley on _my_ code in `requestHandler.ts`. That’s a great start. But I have not changed much since the signature to `requestHandler` still takes in a request and response object. But I have opened up the door to some new opportunties.

While trying to solve this problem I started to think of my request handler as a workflow. Could I define it as tiny steps that compose into the larger request handler? As I researched this I discovered a well defined pattern already exists: the _Chain of Responsibility_. The idea goes something like this:

- Transform the request into an initial state object.
- Define each operation in the workflow as a plain function.
- Create an operation chain that processes each step in order, passing the output to the next step.
- Handle the final success or failure.

Wrapping my head around this took some time as I wrote and rewrote test code exploring the idea. Most of what I coded up got hacked away and I ended up with relatively little code that allows for a decomposed workflow. This means each step is testable in isolation, requiring fewer dependencies, and thus fewer mocks. I ended up with this.

```ts
// operation.ts
export type Operation<T> = (input: T) => Promise<T>
export type OperationCollection<T> = Array<Operation<T>>

export const operationChain = async <T>(
  operations: OperationCollection<T>,
  initialState: T,
): Promise<T> => {
  return await operations.reduce((operation: Promise<T>, next: Operation<T>) => {
    return operation ? operation.then(next) : next(initialState)
  }, undefined)
}
```

While this is better, I was bothered by a few things. So I continued studying the problem. And then I had another forehead-slap moment. You remember that article I referenced at the top? The one about [mocking is a code smell](https://medium.com/javascript-scene/mocking-is-a-code-smell-944a70c90a6a)? I reread it. The author explores decomposing problems into pure functions. For async work a promise-based pattern works well. Towards the bottom he explores this. Specifically he mentions `asyncPipe()`. I went back to my code and reconsidered my problem further. I had basically created an async pipe. Which means I was able to change it to this.

```ts
export type Operation<T> = (state: T) => Promise<T>

export const operationChain = <T>(...ops): Operation<T> => {
  return async (state: T): Promise<T> => {
    return ops.reduce(
      (op: Promise<T>, next: Operation<T>) => op.then(next),
      Promise.resolve(state)
    )
  }
}
```

There are two improvements that I really like.

- It separates building the function that iterates over the operations from actually invoking it with the initial state.
- It removes the unnecessary ternary logic in the previous version by setting the intial value of the reducer to a promise.

> A side note: I would love to define the type of the operation chain like this.
>
> ```ts
> <T>(...ops: OperationCollection<T>): Operation<T>
> ```
>
> But we cannot type variadic parameters in TypeScript, yet; [it is a fetaure in discussion](https://github.com/Microsoft/TypeScript/issues/5453).

So here I am with a simple way to connect promise-based operations together. Now I can get on with TDDing my individual operations.

So I will wrap up with this sample of how I intend to use the `operationChain`.

```ts
// requestHandler.ts
import { operationChain } from "./operationChain"
import { OperationState } from "./OperationState"
import { authorizeUser, processOrder, savePurchase, handleSuccess } from "./operations"
import { operationErrorHandler } from "./operationErrorHandler"

export const requestHandler = (request: Request, response: Response) => {
  const state = new OperationState({ request, response })
  const operations: Array<Operation<OperationState>> = [authorizeUser, processOrder, savePurchase, handleSuccess]
  operationChain(operations)(state).catch(operationErrorHandler)
}
```

```ts
// index.ts
import * as requestHandler from "./requestHandler
export default functions.https.onRequest(requestHandler)
```

The major pieces involed in `requestHandler` are:

- `OperationState`: an immutable value modeling all of the state for the entire workflow.
- `authorizeUser`, `processOrder`, and `savePurchase`: these are the workhorse `Operation` functions.
- `handleSucces`: the final `Operation` function handling our final success response.
- `operationErrorHandler`: handles any high level errors we need to signal the user about.

We could add some integration tests around our `requestHandler` if we needed to. However we have created an architecture that allows us to decompose our workflow. We now have discrete operations that are testable in isolation. Therefore we can test the pieces and more easily trust that the workflow will behave as expected.
