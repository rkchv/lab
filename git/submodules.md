### 📌 Frequently Used Git Submodule Commands

| Command                                      | Description                                                                                   |
|----------------------------------------------|-----------------------------------------------------------------------------------------------|
| `git submodule add <url> <path>`             | Add a new submodule to the repository                                                           |
| `git submodule init`                         | Initialize the submodules (reads from `.gitmodules`)                                           |
| `git submodule update`                       | Update the submodules to the version specified in the parent repository                        |
| `git submodule update --init --recursive`    | Initialize and update all nested submodules                                                     |
| `git submodule status`                       | Show the current versions of all submodules                                                     |
| `git submodule deinit <path>`                | Deinitialize a submodule (remove local files but leave the entry in `.gitmodules`)              |
| `git submodule foreach <cmd>`                | Run a command for each submodule                                                                |
| `git submodule sync`                         | Synchronize submodule URLs with `.gitmodules`                                                   |
| `git rm --cached <path>`                     | Remove a submodule from the repository                                                         |
| `git submodule init && git submodule update`  | Full process of initializing and fetching submodules                                           |
| `git clone --recurse-submodules <url>`       | Clone a repository including its submodules                                                    |

---

### 🔥 Useful Tricks

| Command                                         | Description                                                             |
|-------------------------------------------------|-------------------------------------------------------------------------|
| `git submodule update --remote`                 | Update the submodule to the latest commit from the remote repository     |
| `git submodule set-url <path> <url>`            | Change the URL of a submodule                                          |
| `git submodule summary`                         | Show a brief summary of changes in submodules                           |
| `git submodule absorb`                          | Automatically commit changes to submodules                             |

---

