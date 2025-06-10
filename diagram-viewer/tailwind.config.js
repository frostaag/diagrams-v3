/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // SAP Fiori colors
        'sap-blue': '#0070f3',
        'sap-dark-blue': '#003a6b',
        'sap-light-blue': '#ebf8ff',
        'sap-green': '#107e3e',
        'sap-orange': '#e76500',
        'sap-gray': '#6a6d70',
        'sap-light-gray': '#f7f7f7',
      },
      fontFamily: {
        'sap': ['72', 'Arial', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
