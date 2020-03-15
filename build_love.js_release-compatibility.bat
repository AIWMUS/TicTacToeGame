@echo off
echo Build love.js release-compatibility
cd love.js-master/release-compatibility
python ../emscripten/tools/file_packager.py game.data --preload ../../src@/ --js-output=game.js
