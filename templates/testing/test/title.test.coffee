import { expect } from '@esm-bundle/chai'

it 'Take screenshot', ->
  await page.screenshot
    path: 'example.png'