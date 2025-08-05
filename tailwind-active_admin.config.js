import { execSync } from 'child_process';
import activeAdminPlugin from '@activeadmin/activeadmin/plugin';

const activeAdminPath = execSync('bundle show activeadmin', { encoding: 'utf-8' }).trim();

export default {
  content: [
    `${activeAdminPath}/vendor/javascript/flowbite.js`,
    `${activeAdminPath}/plugin.js`,
    `${activeAdminPath}/app/views/**/*.{arb,erb,html,rb}`,
    './app/admin/**/*.{arb,erb,html,rb}',
    './app/inputs/**/*.{arb,erb,html,rb}',
    './app/components/**/*.{arb,erb,html,rb}',
    './test/components/**/*.{arb,erb,html,rb}',
    './app/views/active_admin/**/*.{arb,erb,html,rb}',
    './app/views/admin/**/*.{arb,erb,html,rb}',
    './app/views/layouts/active_admin*.{erb,html}',
    './app/views/layouts/component_preview*.{erb,html}',
    './app/javascript/**/*.js'
  ],
  darkMode: "selector",
  theme: {
    extend: {
      keyframes: {
        "appear-then-fade": {
          "0%": {
            opacity: "0",
            transform: "translateY(-10px)",
          },
          "15%": {
            opacity: "1",
            transform: "translateY(0)",
          },
          "70%": {
            opacity: "1",
            transform: "translateY(0)",
          },
          "100%": {
            opacity: "0",
            transform: "translateY(-10px)",
          },
        },
      },
      animation: {
        "appear-then-fade": "appear-then-fade 6s 300ms both ease-out",
      },
    },
  },
  plugins: [
    activeAdminPlugin
  ]
}
