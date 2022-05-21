module.exports = {
  branches: [
    '+([0-9])?(.{+([0-9]),x}).x',
    'main',
    { name: 'alpha', prerelease: true },
    { name: 'beta', prerelease: true },
    { name: 'rc', prerelease: true },
  ],
  plugins: [
    ['@semantic-release/commit-analyzer', {
      releaseRules: [
        { breaking: true, release: 'major' },
        { revert: true, release: 'patch' },
        { type: 'feat', release: 'minor' },
        { type: 'fix', release: 'patch' },
        { type: 'perf', release: 'patch' },
        { type: 'refactor', release: 'patch' },
        { type: 'test', release: 'patch' },
        { type: 'ci', release: 'patch' },
        { type: 'docs', release: 'patch' },
        { type: 'deps', release: 'patch' },
        { scope: 'no-release', release: false }
      ]
    }],
    ['@semantic-release/exec', {
      'prepareCmd': 'bin/ci-release-version ${nextRelease.version}'
    }],
    '@semantic-release/release-notes-generator',
    ['@semantic-release/changelog', {
      changelogTitle: '# Jove Changelog'
    }],
    ['@semantic-release/git', {
      assets: ['CHANGELOG.md', 'VERSION']
    }],
    '@semantic-release/github'
  ]
}
