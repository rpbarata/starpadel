module.exports = {
  extends: ["eslint:recommended", "airbnb-base"],
  env: {
    browser: true, // browser global variables
    node: true, // Node.js global variables and Node.js scoping
    jquery: true // jQuery global variables
  },
  rules: {
    // enable additional rules
    indent: ["error", 2],
    "linebreak-style": ["error", "unix"],
    quotes: ["error", "double"],
    semi: ["error", "always"],
    // override default options for rules from base configurations
    "no-cond-assign": ["error", "always"],
    // disable rules from base configurations
    "no-console": "off",
    "comma-dangle": "off",
    "no-restricted-globals": "off",
    "class-methods-use-this": "off",
    "import/extensions": "off",
    "import/no-unresolved": "off",
    "no-unused-vars": "off",
    "no-param-reassign": "off"
  },
  plugins: ["html-erb"],
  parser: "babel-eslint",
};