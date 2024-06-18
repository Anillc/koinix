#!@runtimeShell@
set -u

export PATH=@path@:$PATH

cd locker
if [ ! -d node_modules ]; then
  yarn
fi
./build.sh
cp ./lock/* ../generated
cd ..

hash=$(prefetch-npm-deps ./generated/package-lock.json)
cat > ./generated/hash.nix <<EOF
{
  hash = "$hash";
}
EOF
