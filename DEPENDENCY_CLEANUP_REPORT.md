# DEPENDENCY CLEANUP REPORT

## Unused Production Dependencies (6 packages)

| Package | Why Installed | Actual Usage | Recommendation |
|---------|---------------|--------------|----------------|
| `@tabler/icons-react` | Icons library | Never imported anywhere | SAFE_REMOVE |
| `@vercel/analytics` | Vercel analytics | Never imported in layout or pages | SAFE_REMOVE |
| `@vercel/speed-insights` | Vercel speed insights | Never imported in layout or pages | SAFE_REMOVE |
| `@hookform/resolvers` | Form validation resolvers | react-hook-form used but resolvers never imported | SAFE_REMOVE |
| `is-online` | Network connectivity check | Never imported anywhere | SAFE_REMOVE |
| `use-debounce` | Debounce hook | Never imported anywhere | SAFE_REMOVE |

## Packages to KEEP (despite no direct import)

| Package | Reason |
|---------|--------|
| `@capacitor/android` | Required for Capacitor Android build pipeline |
| `@capacitor/cli` | Required for Capacitor CLI commands |
| `apexcharts` | Peer dependency of react-apexcharts (which IS used) |
| `react-dom` | Core framework dependency |

## Notes
- All Radix UI packages are only needed by the shadcn/ui components we're removing. After removing those 22 UI components, the corresponding Radix packages can also be removed.
- `framer-motion` is still needed by `bentodemo.tsx` (dashboard) which IS used.
