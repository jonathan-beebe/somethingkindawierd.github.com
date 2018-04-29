---
title: Query Params on a Firebase Functions get Request.
---

> An answer I gave on Slack to a question about query params on a get endpoint cloud function.

You should be able to make a `GET` request using query params, e.g. `http://your-domain.com/path?name=firebase` to send the query param `name` with the value of `firebase`.

Then on the cloud function side you can access it like this:

```
functions.https.onRequest((req, res) => {
  const name = request.query.name
}
```

Regarding a Authorization token you can find sample code in the Firebase repo https://github.com/firebase/functions-samples/, such as

- https://github.com/firebase/functions-samples/blob/0cbd4d1777ac19eeed698264c0c1e1e06e0d5917/authorized-https-endpoint/public/main.js
- https://github.com/firebase/functions-samples/blob/9ce5109babd4f3b240d097debdc570dbe7383682/authorized-https-endpoint/functions/index.js

which show how to send the `Authorization` param as a header value on the query
