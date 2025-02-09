# FetchRecipes

### Summary: Include screen shots or a video of your app highlighting its features
Sample project for fetching the data as recipes from the given URL and showing it on the iPhone screen.
An iOS app developed with Swift, SwiftUI, AsyncAwait and Image caching.

[Video Recording](https://drive.google.com/file/d/1JnsCnW9Gd6CTqgR0c9J5DWqVxEbuTKm6/view?usp=sharing)

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
- UI
- Pull to refresh
- Image to show (small image vs large image)
- Image caching
- MVVM

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
- Spent approximately 6-7 hrs
  - UI and setup - 2 hrs
  - Network call - 1 hr
  - Image to show - 2 hrs
  - Image caching - 1 hr
  - Testing - 1 hr

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
- For a better user experience, I loaded the small image first followed by the large image.
- Caching the large images if it is available, otherwise small image

### Weakest Part of the Project: What do you think is the weakest part of your project?
- Currently, image caching is the weakest as it is storing data temporarily. If the app is terminated all the cached images are also deleted.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
