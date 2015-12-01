---
title:  "Hiding the Safari View Controller"
date:   2015-11-30 18:00:00
description: Hiding the Safari View Controller from the screen
published: true
draft: true
---

# Hiding the Safari View Controller

The SFSafariViewController (SVC) is a most welcome addition to the iOS SDK. It is an example of just how much Apple cares about the user experience of iOS & its users’ privacy. Furthermore, the rapid adoption of the Safari View Controller by app developers is testament to the value it offers.

The Safari View Controller opens the door to a more seamless authentication experience for users. Products offering both web-based and app-based experiences can now share a user’s authorized session between Safari and native apps. This leads to better onboarding in a number of scenarios, such as users who have already signed in to the mobile website and then download the mobile app. Now the native app can immediately sign the user in instead of presenting the sign-up or sign-in screens. This is an area of active exploration.

The hand-off from the mobile Safari experience to a native experience has traditionally been a difficult problem to solve. iOS has suffered from a lack of official solutions. Developers have been left to implement their own systems, either in native code or by leveraging embedded web views. 

The Safari View Controller changes this by adding third option. We can implement a responsive sign-in/sign-up experience in traditional web technologies that is available to mobile Safari and within our native app via the SFSafariViewController.

One of the beautiful features of this new view controller is its black-box nature. Developers simply instantiate it with a url and show it. Apple takes the experience from there. And because there is no direct sharing of data between the app and Safari the flow becomes remarkably simple: URL in → URL out.

--

I was toying with this idea and ran into the need to spin-up a Safari View Controller without displaying it to the user. All I wanted to do was silently access my website’s authenticated session, if it existed.

--

However, when leveraging the Safari View Controller for authentication, sometimes we don’t want or need the Safari ui. We simply need to perform some operation in the web-context where the user’s session is authenticated. And here is where the Safari View Controller gets complicated. It does not want to hide.

I will show you three ways to hide the Safari View Controller while still leveraging it for authentication. These are by no means the only way to accomplish this. And none of these are perfect, each coming with their own tradeoffs. But hopefully this will be enough to get you going in the right direction if you need this kind of functionality.

## The Setup

I have created a simple test app for trying out some strategies for hiding the Safari View Controller. Here are a couple of screenshots to show the default view hierarchy as a reference through the rest of the article. 

The default view hierarchy *before* the Safari View Controller has been shown looks like this.

![Default view hierarchy of the  sample app](/assets/images/posts/hiding-sfvc/svc default.png)

And once the Safari View Controller has been displayed it looks like this.

![Normal view hierarchy of the Safari View Controller](/assets/images/posts/hiding-sfvc/svc normal.png)

Notice how the original view controller is no longer displayed in the hierarchy once the Safari View Controller has been fully displayed. This is a byproduct of the default transition, which removes the original view controller that is no longer visible.

## Strategy 1: Adjust Opacity

The simplest and perhaps most straightforward approach is to display the SFSafariViewController, but make it transparent so it is not visible. We must adjust the presentation style so the original view controller does not get removed when the transition is complete.

Here is the snippet for showing a transparent SFSafariViewController, largely inspired by [this gist](https://gist.github.com/rsattar/59c710880d897fb75fda).

```swift
class ViewController: UIViewController {

    ...

    func showHiddenSafariViewController() {
        let url = NSURL(string:"http://somethingkindawierd.com")
        let vc = SFSafariViewController(URL: url!)
        vc.modalPresentationStyle = .OverFullScreen
        vc.view.alpha = 0.0;
        self.showViewController(vc, sender: self)
    }
}
```

The magic that allows this to work is the modal presentation style `.OverFullScreen`. The default presentation style will cause the previous view controller to be removed from the view hierarchy when the transition is complete, leaving us with a black screen.

![Alpha Hack](/assets/images/posts/hiding-sfvc/svc alpha hack.png)

Notice how our views are now in the view hierarchy. But they are covered by the transition view.

**Pros**

- A quick and easy way to hide the SVC ui.
- Effective for short-running tasks.

**Cons**

- Blocks the app’s content, preventing interaction until the SVC has been dismissed.
- Relies on knowing the presenting view controller (perhaps you want to use it in a context where you don’t know which view controller is currently presented.)
- Requires a presented view controller to function. This approach cannot be used to launch an asynchronous task as the app spins up. You cannot show or present a view controller without having a visible window & rootViewController to show it on.

[[Perhaps I can discuss the root view controller issue in depth, with an example of how to get around this]]

## Strategy 2: Custom Animator

This is a slightly more advanced approach than simply setting the opacity, leveraging a custom animator to transition the Safari View Controller to a location off-screen.

The code for this approach is a bit more complex since we must handle the transition ourselves. For this I created a custom `HiddenViewControllerAnimator` that encapsulates the transitioning behavior. From there all I had to do was implement the `UIViewControllerTransitioningDelegate` in my view controller and wire up the Safari View Controller to use this custom transition. Again, part of the magic that allows this to work in the custom modal presentation style `UIModalPresentationStyle.Custom`. 

```swift
class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    ...

    private func showHiddenSafariViewController(controller:SFSafariViewController) {
        // Present off-screen, but still effectively blocking interaction with current content.
        controller.view.userInteractionEnabled = false
        controller.modalPresentationStyle = UIModalPresentationStyle.Custom
        controller.transitioningDelegate = self
        self.presentViewController(controller, animated: true, completion: nil)
    }

    // MARK: UIViewControllerTransitioningDelegate

    ...

}
```

While this does display the Safari View Controller off-screen the transition still leaves a view completely blocking the original content that appears below. Notice how the transition view is still present, but the content layers are not. We have effectively removed the SVC from the display, but our content is still blocked.

![custom transition coordinator](/assets/images/posts/hiding-sfvc/svc custom transition.png)

[[ You can view the full code for this sample here]]

**Pros**

- No alpha hacks — completely hides the SVC from view.

**Cons**

- Relies on a presenting view controller context.
- Covers the app, preventing interaction.
- Most complex of the three solutions.

## Strategy 3: View Controller Containment

This is my favorite approach. Partly because containment seems more pure to the intent of “use, but don’t display.” And because it enables a fun hack where we can leverage a special invisible UIWindow, keeping it out of our main app’s hierarchy (more about this in the next section.) This also enables us to use the SVC before our app has a window of its own, enabling us to get to work sooner. All three methods above required the main app window to be ready to present on top of, so there was no chance to kick off a process earlier.

Here is a snippet of the main code showing how to use a Safari View Controller without displaying anything to the user.

```swift
class ViewController: UIViewController {

    ...

    private func showHiddenSafariViewController(controller:SFSafariViewController) {
        self.addChildViewController(controller)
        self.view.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
        // These three lines ensure the Safari View Controller is completely
        // hidden and does not block interaction with the current screen.
        controller.view.userInteractionEnabled = false
        controller.view.alpha = 0.0
        controller.view.frame = CGRectZero
    }

    private func removeHiddenSafariViewController(controller:SFSafariViewController) {
        controller.willMoveToParentViewController(nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
}
```

And finally here is the resulting view hierarchy…which looks identical to the view hierarchy before we added the Safari View Controller! Perfect.

![view controller containment](/assets/images/posts/hiding-sfvc/svc containment.png)

[[ Clean up these lists since some of them are part of the more advanced use of this tip ]]

**Pros**

- Better expresses the intent.
- Separates the hidden views from the main window hierarchy.
- Does not require a presenting view controller context.
- Operates before the first view controller appears.

**Cons**

- Requires a bit of key-window juggling.

## Strategy 3.5: Custom Window Hierarchy

So far all the above strategies require a UIViewController to be present in the main window hierarchy, which can be a problem. Sometimes you want to access a Safari View Controller as your app is launching up to authenticate the user as soon as possible. There is no window hierarchy available yet. With a little bit of key window shuffling we can use a custom UIWindow to contain a Safari View Controller without the user ever seeing it, and before our app has its own UIWindow that is ready to display on.

...show the stuff...

## Resources

- https://gist.github.com/rsattar/59c710880d897fb75fda
- https://library.launchkit.io/how-ios-9-s-safari-view-controller-could-completely-change-your-app-s-onboarding-experience-2bcf2305137f
- https://speakerdeck.com/huin/oauth-with-sfsafariviewcontroller
- from Apple’s WWDC: http://strawberrycode.com/blog/sfsafariviewcontroller-and-oauth-the-instagram-example/
- challenges: https://twitter.com/tapbot_paul/status/650718740598800384

