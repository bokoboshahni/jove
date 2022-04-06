const colors = require('tailwindcss/colors')
const defaultTheme = require('tailwindcss/defaultTheme')

function withOpacityValue(variable) {
  return ({ opacityValue }) => {
    if (opacityValue === undefined) {
      return `rgba(var(${variable}))`
    }
    return `rgba(var(${variable}) / ${opacityValue})`
  }
}

module.exports = {
  content: [
    './app/components/**/*.{erb,js,rb}',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './lib/jove/ui/utilities.yml'
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        transparent: 'transparent',
        current: 'currentColor',
        black: colors.black,
        white: colors.white,

        'primary': withOpacityValue('--jove-theme-primary'),
        'on-primary': withOpacityValue('--jove-theme-on-primary'),
        'primary-container': withOpacityValue('--jove-theme-primary-container'),
        'on-primary-container': withOpacityValue('--jove-theme-on-primary-container'),
        'secondary': withOpacityValue('--jove-theme-secondary'),
        'on-secondary': withOpacityValue('--jove-theme-on-secondary'),
        'secondary-container': withOpacityValue('--jove-theme-secondary-container'),
        'on-secondary-container': withOpacityValue('--jove-theme-on-secondary-container'),
        'tertiary': withOpacityValue('--jove-theme-tertiary'),
        'on-tertiary': withOpacityValue('--jove-theme-on-tertiary'),
        'tertiary-container': withOpacityValue('--jove-theme-tertiary-container'),
        'on-tertiary-container': withOpacityValue('--jove-theme-on-tertiary-container'),
        'danger': withOpacityValue('--jove-theme-danger'),
        'on-danger': withOpacityValue('--jove-theme-on-danger'),
        'danger-container': withOpacityValue('--jove-theme-danger-container'),
        'on-danger-container': withOpacityValue('--jove-theme-on-danger-container'),
        'success': withOpacityValue('--jove-theme-success'),
        'on-success': withOpacityValue('--jove-theme-on-success'),
        'success-container': withOpacityValue('--jove-theme-success-container'),
        'on-success-container': withOpacityValue('--jove-theme-on-success-container'),
        'notice': withOpacityValue('--jove-theme-notice'),
        'on-notice': withOpacityValue('--jove-theme-on-notice'),
        'notice-container': withOpacityValue('--jove-theme-notice-container'),
        'on-notice-container': withOpacityValue('--jove-theme-on-notice-container'),
        'background': withOpacityValue('--jove-theme-background'),
        'on-background': withOpacityValue('--jove-theme-on-background'),
        'surface': withOpacityValue('--jove-theme-surface'),
        'on-surface': withOpacityValue('--jove-theme-on-surface'),
        'surface-variant': withOpacityValue('--jove-theme-surface-variant'),
        'on-surface-variant': withOpacityValue('--jove-theme-on-surface-variant'),
        'outline': withOpacityValue('--jove-theme-outline')
      },
      opacity: {
        'elevation-1': '.05',
        'elevation-2': '.08',
        'elevation-3': '.11',
        'elevation-4': '.12',
        'elevation-5': '.14',
        'hover': '.08',
        'focus': '.12',
        'press': '.12',
        'drag': '.16',
        'disabled-container': '.12',
        'disabled-content': '.38'
      },
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
        mono: ['"Source Code Pro"', ...defaultTheme.fontFamily.mono]
      },
      fontSize: {
        '2xs': ['.625rem', { lineHeight: '.75rem' }],
        'md': ['1rem', { lineHeight: '1.5rem' }],
      },
      margin: {
        50: '.125rem',
        75: '.25rem',
        100: '.5rem',
        200: '.75rem',
        300: '1rem',
        400: '1.5rem',
        500: '2rem',
        600: '2.5rem',
        700: '3rem',
        800: '4rem',
        900: '5rem',
        1000: '6rem'
      },
      padding: {
        50: '.125rem',
        75: '.25rem',
        100: '.5rem',
        200: '.75rem',
        300: '1rem',
        400: '1.5rem',
        500: '2rem',
        600: '2.5rem',
        700: '3rem',
        800: '4rem',
        900: '5rem',
        1000: '6rem'
      },
      spacing: {
        50: '.125rem',
        75: '.25rem',
        100: '.5rem',
        200: '.75rem',
        300: '1rem',
        400: '1.5rem',
        500: '2rem',
        600: '2.5rem',
        700: '3rem',
        800: '4rem',
        900: '5rem',
        1000: '6rem'
      },
      boxShadow: {
        'elevation-1': '0 1px 3px rgba(0,0,0,.12), 0 1px 3px rgba(0,0,0,.24)',
        'elevation-2': '0 3px 6px rgba(0,0,0,.15), 0 2px 4px rgba(0,0,0,.12)',
        'elevation-3': '0 10px 20px rgba(0,0,0,.15), 0 3px 6px rgba(0,0,0,.10)',
        'elevation-4': '0 15px 25px rgba(0,0,0,.15), 0 5px 10px rgba(0,0,0,.05)',
        'elevation-5': '0 20px 40px rgba(0,0,0,.2)'
      },
      borderRadius: {
        xs: '.25rem',
        sm: '.5rem',
        md: '.75rem',
        lg: '1rem',
        xl: '1.5rem'
      },
      maxWidth: {
        menu: '16rem'
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/line-clamp')
  ]
}
