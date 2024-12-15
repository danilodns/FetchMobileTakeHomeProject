# Fetch Mobile Take Home Project


## Technical Details

### Development Environment:
- **Xcode Version**: 16.1
- **iOS Deployment Target**: 17.0

### Steps to Run the App
    -   Don't need any aditional step in order to have this project run

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
    - I focus on Architecture. I choose this area because after implementation, if we decide to add new features, it will be easy done. 

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
    - I spend around 4 hours
    - I split my time in 5% planing, 30% UI, 45% on the logic behind the sercices and ViewModel and 20% testing

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
    - I decide to create an Class called AsyncImageCached to be used on the View, the same way AsyncImage work. The main difference is because the AsyncImageCached, check for the image on file to see if we already have the image downloaded. This approach make easy to call the class on the view. The side effect is that when we download the image we wait to cache before to show on the screen which can delay a little bit the exposure of the image.
    - I created the Endpoint enum to hold the information about the endpoints, avoiding typo error. With that we can easly call the endpoit url by using **endpoint.url**. For new endpoints just need to add a new case.

### Weakest Part of the Project: What do you think is the weakest part of your project?
    - I feel that my project is very solid. I could say that the UI test may be the weakest part.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
    - I created two methods to expose the app to malformad results and alse empty result. To use those function just uncomment and call them. I left commented because this is not part of the final solution, they are just for see in live.
