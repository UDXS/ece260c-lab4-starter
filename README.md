# ECE 260C Lab 4: Modifying & Extending OpenROAD

This lab will be completed in GitHub Codespaces. You will not need to make any other submissions.

**Name:** Your Name Here
**PID:** Your PID Here

## Introduction

In Lab 2, you worked with the Python APIs to do tasks like placement or swapping masters. In Lab 3, you built a buffer insertion predictor with a [dataset that was generated for you](https://huggingface.co/datasets/udxs/vlsi-simple-buffering) using OpenROAD's Python API. 

In both cases, Python made it possible to write and revise scripts incredibly quickly but this came at the cost of performance, which is a challenge when we want to run more complex algorithms on larger databases. We need to be able to take advantage of the same powerful APIs but without the performance hit. 

Thanks to the open-source nature of OpenROAD, this is possible. By writing native C++ to interact with the database and OpenROAD's various subsystems, we can get far better performance. 

In this lab, you will build a resizer that detects ERC violations on nets and applies gate upsizing to fix them. These rely on the exact same OpenSTA calls that [OpenROAD's `rsz`](https://github.com/The-OpenROAD-Project/OpenROAD/tree/master/src/rsz) uses. 

With source editing, we can do anything between just writing faster versions of our scripts (with access to more internal data) to implementing whole new subsystems. The resizer we build here, called `ToySizer`, will be added as part of OpenROAD's `dbSta` subsystem - which defines the interface between OpenSTA's data structures and OpenDB. We chose this subsystem exactly because it gives us access to OpenSTA's APIs.

If you remember from the lecture on Databases and STA, there is a callback-based interplay that connects the database with all the subsystems, notifying them with netlist changes. OpenSTA uses this mechanism to maintain its own timing graph/database that mirrors the entries in OpenDB. Below is a list of some of the terms that OpenSTA uses and their OpenDB equivalents (you may wish to refer to the Databases lecture):

| **OpenSTA** | **OpenDB** |
|-------------|------------|
| Network     | Database   |
| Instance    | dbInst     |
| LibertyCell | dbMaster   |
| LibertyPort | dbMTerm    |
| Pin         | dbITerm    |

You will be editing `ToySizer.cc` to complete the implementation of all the functions required for resizing. Broadly, for each instance, you will get max slew/capacitance information for its master. Using that data, you will determine if the instance is undersized. If so, you will upsize it to the next largest drive strength. This is a simple, imperfect algorithm but it will deliver interesting results. The real `rsz` implements more complex cost functions for determining the required drive strength against size, alongside buffer insertion or even full gate cloning.


Ready? Continue to the instructions below.


## Working on and Submitting this Lab

This lab is running in a new remote container on GitHub Codespaces. This introduces a new way to work on and turn in your code. Here's the process:

1. First, allow Codespaces to build the container. This can take a few minutes.
2. Create a new Terminal at the bottom (you may need to click the + button). Please ensure you do not create multiple. **Do this only after the `Building codespace...` popup disappears.**
3. The first time you do this, it may take a few minutes to start as it unpacks the OpenROAD sources.
4. Afterwards, with an open interactive terminal (you'll see the `ece 260c` logo), you can type `make open` to load the lab and open the workspace. You will find the `sta/` and `dbSta/` folders in the sidebar and the `ToySizer.cc`/`ToySizer.hh` files open. You may need to call `make open` twice if they don't appear the first time.
5. After reading the introduction above, you can complete `ToySizer.cc` (it will be opened for you). Remember to save your work.
6. When you're ready, try building with `make build`. Here, you can resolve build errors.
7. When your code builds successfully, you can run `make test`. The test script will give the results of your program alongside some expected value ranges.
8. When you're done, run `make turnin`. This will run testing one more time and then automatically turn in your code changes and your test results.
9. Re-open your lab repo and make sure there's a commit labled `Turn-in` present. You should also check to make sure that `turnin.patch` or the files in `results/` are not empty.

### Tips & Notes
    
- **You should NOT call Git commands yourself for this lab.**
- You can find `ToySizer.cc` in `dbSta/src/ToySizer.cc`
- You can find `ToySizer.hh` in `dbSta/include/db_sta/ToySizer.hh`. This is a header file that defines the functions you will need to implement in `ToySizer.cc`. You shouldn't edit this – it should be used as a reference.
- You shouldn't need to edit any files outside of `ToySizer.cc`
- If you are interested in seeing how the custom commands are implemented, check out `dbSta.i` and `dbSta.tcl` in `dbSta/src`. You do not need to edit these.
- You can do `make run` to open an interactive OpenROAD shell with our custom commands `toy_resize` and `toy_count_undersized`. This isn't necessary to complete the lab.
- The `sta/` folder is available in the sidebar as a reference for STA's data types.


You can always reopen this codespace by clicking the button at the top of this README or by pressing `,` on your keyboard on the repo page.


--- 

Created by Davit Markarian.
\
Copyright &copy; 2025 The Regents of the University of California. Do not redistribute. 