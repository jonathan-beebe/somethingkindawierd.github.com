---
title: Multiple Return Types in TypeScript
---

I found myself wanting to describe the authorization status of a user in my app. In TypeScript I had:

```ts
export enum AuthStatus {
  MissingToken,
  InvalidToken,
  Unauthorized,
  Authorized
}
```

In the case of successful authorization where the return value of a function might be `AuthStatus.Authorized` I want to also return the associated value, the user object, that was authorized.

In Swift I can say something like this:

```ts
class User {...}

enum AuthStatus {
  case MissingToken
  case InvalidToken
  case Unauthorized
  case Authorized(user: User)
}
```

Another way of saying what I want to do is: I want a function capable of returning _both_ the auth state & the authorized user if one exists. At first that felt like I was mixing two concerns together. Here is why I want this behavior:

1. The user is only ever generated when auth is successful. That is the only state where it makes sense to have a value.
2. The third party library I am using to perform authorization verifies the auth token an returns a user. So I would be using the same function to calculate the state and to access the user value. Breaking those two parts into separate functions makes little sense in this context.

In TypeScript I found a few ways to represent two return types.

- A union return type.
- A tuple.
- A composite object.

## Union Return Type

A function that can return either an `AuthStatus` value or the authorized user.

```ts
function authorizeWithToken(token: string): AuthStatus | User {...}
```

## Tuple

A single value encapsulating both the status and the user object.

```ts
interface ValueOrError<V, E> extends Object { value?: V; error?: E; }
```

Which can be used like this for an unauthorized user:

```ts
return ValueOrError<User, AuthStatus> = { error: AuthStatus.Unauthorized }
```

And for an authorized user:

```ts
return ValueOrError<User, AuthStatus> = { value: myAuthorizedUserObject }
```

So in this case we either have an `error` value describing why the `value` is missing. Or we have no `error` and a well defined `value` property.

## Composite Object

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

function(token?: string): Promise<User> {
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