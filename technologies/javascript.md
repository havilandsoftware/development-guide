# JavaScript (Node.js v22)
JavaScript is the core language that powers our API and UI applications.

## Installation
1. Install [nvm](https://github.com/nvm-sh/nvm#installing-and-updating) to control the local version of Node.js and npm
2. Run `nvm use v22.12.0`
3. Add the command above to the `~/.bashrc` so that the terminal automatically selects the correct version.
3. Install [Angular CLI](https://github.com/angular/angular-cli) with the command `npm install -g @angular/cli`.

## Frameworks

### Next.js
Next.js is our React framework for building production-ready web applications with server-side rendering and static site generation.

**Installation:**
```bash
npx create-next-app@latest
```

**Key Features:**
- Server-side rendering (SSR) and static site generation (SSG)
- File-based routing
- API routes
- Built-in optimization for images, fonts, and scripts

For complete documentation, see [Next.js Documentation](https://nextjs.org/docs).

### Tailwind CSS
Tailwind CSS is our utility-first CSS framework for rapidly building custom user interfaces.

**Installation in a project:**
```bash
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

**Basic Configuration:**
Configure your `tailwind.config.js` to include your template paths:
```javascript
module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

For complete documentation, see [Tailwind CSS Documentation](https://tailwindcss.com/docs).
