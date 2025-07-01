Challenge Statement:  iOS

Create an app which uses the NASA APOD API (https://github.com/nasa/apod-api).

Basic Features:

- On launch of the app, it should load the date, title, image, and the explanation for the current day's APOD (Astronomy Picture of the Day).  ✅ 

- On some days, the image is replaced by an embedded video. The app should handle this scenario as well. (Example 11th October 2021 APOD).  ✅

Uses webkit implementation because Youtube videos are used. Lots of extra stuff to reduce YouTube branding and block automatic fullscreen, so that the video plays tidily above explanation. Commented hard coded video example date included in ContentView.

- Please ensure to use a Tab Bar as it will help when later you are asked to expand on the solution.  ✅ 

iOS 16 friendly Tab Bar used, with option to view text or image only, just as a 'pretty' placholder for tabs.

- Allow the user to load the NASA APOD for any day that they want.  ✅ 
- Last service call including image should be cached and loaded if any subsequent service call fails.  ✅

Attempts to load last cached APOD object and image on network or service failure. Removes existing cache when saving. Youtube videos are obviously not cached.
 
Bonus Features:
- Solution should work on both iPhone and iPad and different orientations.  ✅ 

Works on both iPhone and iPad, with basic orientation conditions for padding to avoid overlap of iPhone status bar in landscape.

- Dark Mode support.  ✅ 

Because I have used SwiftUI, the user mode is automatically catered for.

- Dynamic Type Accessibility.  ✅ 

Because I have used SwiftUI, the Dynamic Type Accessibility is automatically catered for. All text will scale with Accessibility settings.
 
The solution should be production ready, and the candidate is requested to upload the code to GitHub (or any public repository) and share the link with the team when completed. 
Bonus features are not compulsory and any solutions without them will be evaluated as normal. 
The coding style, architecture, testability, stability, and extendibility of the solution will be assessed by the team.

The minimum deployment target of the solution should be iOS 16.0.  ✅ 

Candidates are requested to not use any third-party frameworks and to not use any confidential, proprietary, or sensitive information in the code.  ✅ 

Any solution will be used for JPMC's internal purposes only.