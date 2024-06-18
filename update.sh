#!@runtimeShell@
set -u

export PATH=@path@:$PATH

REGISTRY="$(curl -L https://registry.koishi.chat)"
DEPS="$(echo "$REGISTRY" | jq '[.objects[].package | { (.name): .version }] | add')"
PJ=$(echo "$DEPS" | jq '{
  name: "lock",
  version: "0.0.0",
  dependencies: [., { koishi: "*" }] | add,
}')

rm -rf generated && mkdir -p generated
cd generated
echo $PJ > package.json
npm i --package-lock-only --legacy-peer-deps
HASH="$(prefetch-npm-deps package-lock.json)"
echo "{ hash = \"$HASH\"; }" > hash.nix
