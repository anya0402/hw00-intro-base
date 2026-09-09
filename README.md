# HW 0: Intro to Javascript and WebGL

<p align="center">
  <img width="360" height="360" src="https://user-images.githubusercontent.com/1758825/132532354-e3a45402-e484-499e-bfa7-2d73b9f2c946.png">
</p>
<p align="center">(source: Ken Perlin)</p>

## Final Result
<p align="center">
  <img width="450" src="cube2.gif">
</p>
<p align="center">Link: https://anya0402.github.io/hw00-intro-base/</p>

1. This cube's fragment shader alters the fragment color using fBM (Fractal Brownian Motion) noise. I used a simple implementation of fBM as the base function of noise, and made it 3D so that it would fit with a cube. Then, I took inspiration from Inigo Quilez's implementation of warping, or domain distortion, to add more patterns into the color. This method is basically distorting the input to the fBM with another fBM. I warp twice, which creates the cloud-like patterns in the noise. Next I add color to the noise by using mix functions, along with smoothstep to blend the colors together. One extra constraint I added was to clamp the color to be at or above 160 in the 0-255 RGB scale. This is because the users are allowed to choose whatever input color they want to edit the color of the cube, and I didn't like how it looked when the RGB color had values below 160.

2. This cube's vertex shader alters the cube vertex positions based on time. I wanted to use a sinc function, but since it decays infinitely, I wanted to make it periodic so that the amplitude goes back up over time. I found that a periodic sinc function is called a Dirichlet kernel, so I used that equation to create a displacement of the vertices based on the fragment normal. 


## Objective
- Check that the tools and build configuration we will be using for the class works.
- Start learning Typescript and WebGL2
- Practice implementing noise

## Forking the Code
Rather than cloning the homework repository, please __fork__ the code into your own repository using the `Fork` button in the upper-right hand corner of the Github UI. This will enable you to have your own personal repository copy of the code, and let you make a live demo (described later in this document).

## Running the Code

1. [Install Node.js](https://nodejs.org/en/download/) (the current LTS release). Node.js is a JavaScript runtime. It basically allows you to run JavaScript when not in a browser. For our purposes, this is not necessary. The important part is that with it comes `npm`, the Node Package Manager. This allows us to easily declare and install external dependencies such as [dat.GUI](https://workshop.chromeexperiments.com/examples/gui/#1--Basic-Usage), and [glMatrix](http://glmatrix.net/).

2. Using a command terminal, run `npm install` in the root directory of your project. This will download all of those dependencies. On Windows, you may encounter an error message telling you that running scripts is disabled on your system (common if you've not used the command prompt on your computer before). To fix this, run this command: `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`

3. Do either of the following (but we highly recommend the first one for reasons we will explain later).

    a. Run `npm run dev` (or `npm start`) and then go to `localhost:5660` in your web browser

    b. Run `npm run build` and then run `npm run preview` to serve the built `dist/` folder locally

4. A successfully built and run base code should produce the scene shown below. Note: This project was only tested in the Chrome web browser; rendering issues may occur with other browsers.
![](base_render.png)

## Module Bundling
One of the most important dependencies of our projects is [Vite](https://vite.dev/guide/). Vite is a dev server and module bundler which allows us to write code in separate files and use `import`s and `export`s to load classes and functions from other files. It also allows us to preprocess code before compiling to a single bundle. We will be using [Typescript](https://www.typescriptlang.org/docs/home.html) for our WebGL assignments in this course, which is Javascript augmented with type annotations. Vite converts Typescript files to Javascript on the fly during development and bundles/type-checks everything when you run `npm run build`. Read more about Javascript modules in the resources section below.

## Developing Your Code
All of the TypeScript code you will be editing can be found within the `src` directory. The "main" file that gets executed when you load the page is `main.ts`, though you should read through the other files to understand how the shaders and geometry are set up. The reason that we highly suggest you run your project with `npm run dev` is that doing so will start a process that watches for any changes you make to your code. If it detects anything, it'll automatically rebuild the affected parts of your project and hot-refresh your browser window for you. If you do it the other way (`npm run build`), you'll need to re-run that command and then refresh your page every time you want to test something.

## Assignment Details
1. Take some time to go through the existing codebase so you can get an understanding of syntax and how the code is architected. Much of the code is designed to mirror the class structures used in CIS 4600's OpenGL assignments, so it should hopefully be somewhat familiar.
2. Take a look at the resources linked in the section below. Definitely read about Javascript modules and Typescript. The other links provide documentation for classes used in the code.
3. Add a `Cube` class that inherits from `Drawable` and at the very least implement a constructor and its `create` function. Then, add a `Cube` instance to the scene to be rendered.
4. Read the documentation for dat.GUI below. Update the existing GUI in `main.ts` with a parameter to alter the color passed to `u_Color` in the Lambert shader.
5. Write a custom fragment shader that implements FBM, Worley Noise, or Perlin Noise based on 3D inputs (as opposed to the 2D inputs in the slides). This noise must be used to modify your fragment color. If your custom shader is particularly interesting, you'll earn some bonus points.
6. Write a custom vertex shader that uses a trigonometric function (e.g. `sin`, `tan`) to non-uniformly modify your cube's vertex positions over time. This will necessitate instantiating an incrementing variable in your Typescript code that you pass to your shader every tick. Refer to the base code's methods of passing variables to shaders if you are unsure how to do so.
7. Feel free to update any of the files when writing your code. The implementation of the `OpenGLRenderer` is currently very simple.

## Making a Live Demo
When you push changes to the `master` branch of your repository on Github, a Github workflow will run automatically which builds your code with Vite and deploys it straight to GitHub Pages (no separate `gh-pages` branch involved). The configuration file which handles this is located at `.github/workflows/build-and-deploy.yml`. If you want to modify this, you can read more about workflows [here](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions).

Before your first push, tell GitHub to serve Pages from Actions instead of a branch:

  1. Open the Settings tab of your repository in Github.

  2. Scroll down to the Pages tab of the Settings (in the table on the left).

  3. Under "Build and deployment" -> "Source", select **GitHub Actions**. You only need to do this once.

  4. Push (or re-push) to `master`. The workflow will build your project and deploy it automatically. The project should be visible at http://username.github.io/repo-name.

To check if everything is on the right track:

1. Go to the **Actions** tab of your repo and confirm the latest "Build and Deploy" run finished with a green checkmark (both the `build` and `deploy` jobs).

2. In the Settings tab, under Pages, make sure it says your site is published at some URL. Clicking the URL should show your live demo.

> **Note:** If the workflow fails on its very first run with an error about the `github-pages` environment not existing, that just means step 3 above (selecting "GitHub Actions" as the source) hasn't been done yet. Perform step 3, then re-run the failed workflow from the Actions tab.

## Submission
1. Create a pull request to this repository with your completed code.
2. Update README.md to contain a solid description of your project with a screenshot of some visuals, and a link to your live demo.
3. Submit the link to your pull request on Canvas, and add a comment to your submission with a hyperlink to your live demo.
4. Include a link to your live site.

## Resources
- Javascript modules https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import
- Typescript https://www.typescriptlang.org/docs/home.html
- dat.gui https://workshop.chromeexperiments.com/examples/gui/
- glMatrix http://glmatrix.net/docs/
- WebGL
  - Interfaces https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API
  - Types https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API/Types
  - Constants https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API/Constants