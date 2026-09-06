
# root of the project
cd ..

flutter build macos --release

mkdir -p build/macos/pkg

productbuild \
  --component "build/macos/Build/Products/Release/File Sharing Plus.app" \
  /Applications \
  --sign "3rd Party Mac Developer Installer: Oleksandr Naumenko (G6JU9XRSX4)" \
  "build/macos/pkg/File-Sharing-Plus.pkg"

xcrun altool --upload-app  -f build/macos/pkg/File-Sharing-Plus.pkg -t macos -u "alexandr132135@gmail.com" --app-password "tgug-aihh-mrpg-ppei"

