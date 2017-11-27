cd ../kumano-dormitory.github.io
rm -r ryosai2017
cp -r ../ryosai2017/_site/ryosai2017 .
git add .
git commit -m "auto deploy"
git push
cd ../ryosai2017
