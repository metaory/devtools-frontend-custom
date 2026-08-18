# Historical upstream build steps

This snapshot is retained as reference only. Its
`out/Default/resources/inspector` output path is obsolete. Use
[`steps-raw.md`](steps-raw.md) for this repository.

The client-side of the Chrome DevTools, including all JS & CSS to run the DevTools webapp.

Source code
The frontend is available on chromium.googlesource.com.

Workflows
In order to make changes to DevTools frontend, build, run, test, and submit changes, several workflows exist. Having depot_tools set up is a common prerequisite.

Standalone workflow
As a standalone project, Chrome DevTools frontend can be checked out and built independently from Chromium. The main advantage is not having to check out and build Chromium. However, there is also no way to run layout tests in this workflow.

Checking out source
To check out the source for DevTools frontend only, follow these steps:

mkdir devtools
cd devtools
git clone https://chromium.googlesource.com/devtools/devtools-frontend
gclient config https://chromium.googlesource.com/devtools/devtools-frontend --unmanaged
Build
To build, follow these steps:

cd devtools-frontend
gclient sync
gn gen out/Default
autoninja -C out/Default
The resulting build artifacts can be found in out/Default/resources/inspector.

Run in Chromium
These steps work with Chromium 79 or later. To run the production build, use

(Requires brew install coreutils on Mac.)

<path-to-chrome>/chrome --custom-devtools-frontend=file://$(realpath out/Default/resources/inspector)
To run the debug build (directly symlinked to the original unminified source files), build both Chromium and DevTools frontend with the GN flag debug_devtools=true, and use

<path-to-chrome>/chrome --custom-devtools-frontend=file://$(realpath out/Default/resources/inspector/debug)
You can inspect DevTools with DevTools by undocking DevTools and then open the developers tools (F12 on Windows/Linux, Cmd+Option+I on Mac).

Test
Test are available by running scripts in scripts/test/.

Create a change
Usual steps for creating a change work out of the box.

Managing dependencies
To sync dependencies from Chromium to DevTools frontend, use scripts/deps/roll_deps.py.
To roll the HEAD commit of DevTools frontend into Chromium, use scripts/deps/roll_to_chromium.py.
To update DevTools frontend's DEPS, use roll-dep.
Chromium workflow
DevTools frontend can also be developed as part of the full Chromium checkout.

Checking out source
Follow instructions to check out Chromium. DevTools frontend can be found under third_party/devtools-frontend/src/.

Build
Refer to instructions to build Chromium. To only build DevTools frontend, use devtools_frontend_resources as build target. The resulting build artifacts for DevTools frontend can be found in out/Default/resources/inspector.

Consider building with the GN flag debug_devtools=true to symlink to the original unminified source.

Run
Run Chrome with DevTools frontend bundled:

out/Default/chrome
Test
Test are available by running scripts in third_party/devtools-frontend/src/scripts/test/. After building content shell, we can also run layout tests that are relevant for DevTools frontend:

autoninja -C out/Default content_shell
third_party/blink/tools/run_web_tests.py http/tests/devtools
Create a change
Usual steps for creating a change work out of the box, when executed in third_party/devtools-frontend/src/.

Integrate standalone checkout into Chromium
If you prefer working on a standalone checkout of DevTools frontend, but want to build, test, and run inside the full Chromium checkout. This way, you combine the best of both worlds.

Disable gclient sync for DevTools frontend inside of Chromium by editing .gclient config. From chromium/src/, simply run

vim $(gclient root)/.gclient
In the custom_deps section, insert this line:

"src/third_party/devtools-frontend/src": None,
Then run

gclient sync -D
This removes the DevTools frontend dependency. We now create a symlink to refer to the standalone checkout:

(Note that the folder names do NOT include the trailing slash)

ln -s path/to/standalone/devtools-frontend third_party/devtools-frontend/src
Running gclient sync in chromium/src/ will update dependencies for the Chromium checkout. Running gclient sync in chromium/src/third_party/devtools-frontend/src will update dependencies for the standalone checkout.

Testing
Please refer to the overview document. The current test status can be seen at the test waterfall.

Additional references
DevTools documentation: devtools.chrome.com
Debugging protocol docs and Chrome Debugging Protocol Viewer
awesome-chrome-devtools: recommended tools and resources
Contributing to DevTools: bit.ly/devtools-contribution-guide
Contributing To Chrome DevTools Protocol: docs.google.com
Useful Commands
npm run format-py
Formats your Python code using yapf

Note: Yapf is a command line tool. You will have to install this manually, either from PyPi through pip install yapf or if you want to enable multiprocessing in Python 2.7, pip install futures

Source mirrors
DevTools frontend repository is mirrored on GitHub.

DevTools frontend is also available on NPM as the chrome-devtools-frontend package. It's not currently available via CJS or ES2015 modules, so consuming this package in other tools may require some effort.

The version number of the npm package (e.g. 1.0.373466) refers to the Chromium commit position of latest frontend git commit. It's incremented with every Chromium commit, however the package is updated roughly daily.
