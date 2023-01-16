#  JSONPlaceholderToy

Architecture:

One liner explanation: Model -> LazyObject -> DataStore -> ViewController -> Storyboard

Multi-line explanation:

- Models are dumb in Models.swift
- Networking is done in a generic class LazyObject, you can think of it as NetworkModel<Model>, RemoteModel<Model>, etc
- LazyObjects are stored in DataStore
- DataStore has convenience methods/attributes for modifying/accessing data in UI
- UI is in view controllers and a storyboard
- UI (ViewControllers) observe the status state of LazyObjects and refresh the UI whenever it changes via Combine

Notes: 

- there's pull to refresh on the main page
- using KVO (NSObject and @objc dynamic is great vs @Published for status in LazyObject because with @Published status you'd need to write encode/decode by hand and that's no fun)
- Data gets stored in UserDefaults upon app going to backgrond in SceneDelegate, gets restored if possible in DataStore's init
- It was bothering me to use a table cell for author/post description in DetailVC so I went and googled if I can get me a tableview inside a scrollview, like I would in a SwiftUI project. To my surprise, it is quite easy and that approach is in CombinedVC - I thought I'd leave it in because I had no idea this was possible *and* easy to do, pretty cool :)

What about unit tests?

- I don't want to write 10 lines of unit tests for 8 lines of code unless I'm getting paid to do so, in which case I'm happy to write any desired amount :)
- Here is a link to a paid homework assignment where I did add unit tests just to show that I know how:
https://github.com/desugaring/HackerNewsApp/tree/main/HackerNewsAppTests

- Notice the architecture in the the other project is a bit different - I just do whatever works best for the project, for example the use of LazyObject wouldn't work in the other project because it uses SwiftUI and SwiftUI doesn't play nicely with data classes, only structs.
