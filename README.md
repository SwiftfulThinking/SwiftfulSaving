# SwiftfulSaving 🦉

Native data persistence for iOS applications. 

**Setup time:** 5 minutes

**Sample project:** https://github.com/SwiftfulThinking/SwiftfulSavingExample

## Overview 🤓

Almost every native iOS application requires some form of local data persistence. This framework attempts to abstract that logic so that developers can save any type of data with a few lines of code.

## Setup ☕️

Add the package to your xcode project

```
https://github.com/SwiftfulThinking/SwiftfulSaving.git
```

Import the package

```swift
import SwiftfulSaving
```

SwiftfulSaving supports saving to:
- FileManager (FM)
- CoreData (CD)
- UserDefaults (UD)

Generally, saving data requires the following steps:

1. Create a parent-level directory where data will be saved
2. Create a child-level service within the parent-level directory
3. Conform your data type to the appropriate protocols
4. Use the service to perform the operations

See the [Wiki](https://github.com/SwiftfulThinking/SwiftfulSaving/wiki) for full documentation (in progress).

