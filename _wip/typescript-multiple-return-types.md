---
title: Multiple Return Types in TypeScript
---

In this article I want to explore a situation where I need multiple return types from a single function. (I don’t much care to argue whether this is a _good_ idea or not. It’s probably not. But I am constrained by a third party library I am trying to wrap, hence the reason I am bothering to explore this pattern.)

I want a function `authorizerWithToken` that takes in a token string and returns the user’s auth status. And, if the user is authorized, I want the user object as well.

The various states that this function can return are described in this enum.

```ts
export enum AuthStatus {
  MissingToken,
  InvalidToken,
  Unauthorized,
  Authorized
}
```

If I was in my more comfortable world of iOS apps & Swift I might describe it like this.

```swift
enum AuthStatus {
  case MissingToken
  case InvalidToken
  case Unauthorized
  case Authorized(user: User)
}
```

In Swift the `User` type on `Authorized` is called an _associated value_. It guarentees the `.Authorized` case has the user object associated with it. Since TypeScript does not have associated values with enums, how can I accomplish the same thing? I came up with three ideas to effectively return two values from one function.

- A union return type.
- A tuple.
- A composite object.

## Union Return Type

The union return type is a way of describing a function that can return a type of _either_ `AuthStatus` _or_ `User`. We can describe that in TypeScript using `AuthStatus | User`. Technically this is not returning two values. Instead it can return two types of values, depending on which is appropriate. So in the case of an authorized user we would not bother with the `AuthStatus.Authorized` value. We would instead return the actual user object. It might look something like this.

```ts
function authorizeWithToken(token: string): AuthStatus | User {...}
```

## Tuple

A _tuple_ is a way of describing a data structure with a guaranteed number and sequence of elements. You can read more about [TypeScript tuples in the handbook](https://www.typescriptlang.org/docs/handbook/basic-types.html). Our return type might look like this, where we put the auth status first and the  user second.

```ts
type UserAuthState: [AuthStatus, User]
```

So our function would look something like this.

```ts
// Failed auth case
function authorizeWithToken(token: string): UserAuthState {
  // auth failed here...
  return [AuthStatus.Unauthorized, undefined]
}
```

```ts
// Authorized Case
function authorizeWithToken(token: string): UserAuthState {
  // Perform successful authorization here...
  return [AuthStatus.Authorized, user]
}
```

## Composite Object

I’m sure there are more than two ways of doing this. But I explored two ways of composing an object that descibes the data I need returned from my function. The first involves a custom type that wraps the actual value(s). The second approach uses a custom class.

### Boxing Interface

..., declares my intent to return the user value on success _or_ the error case

A single value encapsulating both the status and the user object.

```ts
interface ValueOrError<V, E> extends Object { value?: V; error?: E; }
```

Which can be used like this for an unauthorized user:

```ts
// Failed auth case
function authorizeWithToken(token: string): ValueOrError<User, AuthStatus> {
  // auth failed here...
  return ValueOrError<User, AuthStatus> = { error: AuthStatus.Unauthorized }
}

And for an authorized user:

```ts
// Authorized Case
function authorizeWithToken(token: string): ValueOrError<User, AuthStatus> {
  // Perform successful authorization here...
  return ValueOrError<User, AuthStatus> = { value: user }
}
```

So in this case we either have an `error` value describing why the `value` is missing. Or we have no `error` and a well defined `value` property.

### Custom Class

This is a more formal version of the tuple.

```ts
class UserAuthStatus {
  constructor(public user?: User, public error?: AuthStatus)
}
```

What I dislike about the second two techniques is the user value is always optional. It allows for the possibility for the error and the value to be in an incorrect state, e.g. error missing and user missing. Or a defined errer _and_ a defined user. I want a type that will have _either_ an error or, in the sucessful case, a non-optional user value.

This is where the Swift enum with an associated value really shines. I get both a confirmation of the successful status _and_ I am assured a well defined user value.

After a lot of experimentation I realized Promises also gave me what I was looking for. They offer a typed value on success with `Promise<User>` and a flexible error value for any of the unsuccessful paths.

```ts
class User {...}

export enum AuthStatus {
  MissingToken,
  InvalidToken,
  Unauthorized,
  Authorized
}

function authorizerWithToken(token?: string): Promise<User> {
  return new Promise<User>(async (resolve, reject) => {
    if(token == undefined) {
      reject(AuthStatus.MissingToken)
      return
    }

    const tokenId = extractTokenId(token)

    if(tokenId == undefined) {
      reject(AuthStatus.InvalidToken)
      return
    }

    try {
      resolve(await verifyUserWithTokenId(tokenId))
    }
    catch (error) {
      resolve(AuthStatus.Unauthorized)
    }
  })
}
```