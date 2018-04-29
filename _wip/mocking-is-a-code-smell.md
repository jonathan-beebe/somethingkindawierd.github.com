---
title: Mocking is a Code Smell
---

[From Eric Elliott](https://medium.com/javascript-scene/mocking-is-a-code-smell-944a70c90a6a)

> I’ve seen developers get so lost in mocks, fakes, and stubs that they wrote entire files of unit tests where no actual implementation code was exercised at all. Oops.

That’s been me :(

> TDD tends to have a simplifying effect on code, not a complicating effect. If you find that your code gets harder to read or maintain when you make it more testable, or you have to bloat your code with dependency injection boilerplate, **you’re doing TDD wrong**.

Empchasis mine.

> mutation isn’t always faster, and it is often orders of magnitude slower because it takes a micro-optimization at the expense of macro-optimizations.

Optimizations are a topic that comes up often in my circle.