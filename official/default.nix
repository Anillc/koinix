{
fetchFromGitHub,
mkYarnPackage,
...
}:

mkYarnPackage {
  name = "koishi";
  yarnLock = ./yarn.lock;
  src = fetchFromGitHub {
    owner = "koishijs";
    repo = "koishi";
    rev = "4.11.7";
    sha256 = "sha256-8iqDhYcC39Hpe74g/TvPvpaioaEt6DtPwVOKxWKZMaw=";
  };
}