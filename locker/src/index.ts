import { SearchResult } from '@koishijs/registry'
import { promises as fsp } from 'fs'

;(async () => {
  const search: SearchResult = await fetch('https://registry.koishi.chat').then(res => res.json())
  const packages = search.objects.filter(object => !object.ignored)
  const pj = {
    name: 'lock',
    version: '0.0.0',
    dependencies: packages.reduce((acc, x) => {
      acc[x.package.name] = `^${x.package.version}`
      return acc
    }, { koishi: '*' }),
  }
  await fsp.mkdir('./lock', { recursive: true })
  await fsp.writeFile('./lock/package.json', JSON.stringify(pj))
})()