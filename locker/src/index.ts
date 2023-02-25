import Scanner from '@koishijs/registry'
import axios from 'axios'
import { promises as fsp } from 'fs'

;(async () => {
  const scanner = new Scanner(async url => {
    const { data } = await axios.get('https://registry.npmjs.com' + url)
    return data
  })
  await scanner.collect()
  const dependencies = scanner.objects.reduce((acc, x) => {
    acc[x.package.name] = `^${x.package.version}`
    return acc
  }, {
    koishi: "*"
  })
  const pj = {
    name: 'lock',
    version: '0.0.0',
    dependencies,
  }
  await fsp.mkdir('./lock', { recursive: true })
  await fsp.writeFile('./lock/package.json', JSON.stringify(pj))
})()