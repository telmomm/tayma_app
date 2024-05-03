# TAYMA APP

A new Flutter project.


### MKDocs
https://www.mkdocs.org/getting-started/
https://squidfunk.github.io/mkdocs-material/plugins/projects/?h=project

mkdocs serve
mkdocs build

### Flutter Commands
flutter clean
clutter pub get

flutter devices
flutter run

## GIT
Inicializa un nuevo repositorio Git con el comando git init.

    git init

Luego, agrega todos tus archivos al repositorio con git add ..

    git add .

Haz un commit de tus cambios con git commit -m "mensaje del commit".

    git commit -m "Primer commit"

Ahora, necesitas conectar tu repositorio local con tu repositorio en GitHub. Puedes hacer esto con git remote add origin URL_DEL_REPO.

    git remote add origin https://github.com/username/tayma_app.git

Finalmente, puedes subir tus cambios a GitHub con git push -u origin master.

    git push -u origin master

## DEPLOY
### APK GENERATOR
#### MANUAL
https://medium.com/@flutterinastudio/generar-una-apk-sencilla-android-application-package-desde-flutter-para-dispositivos-android-159464775649

#### STEPS
flutter build apk --split-per-abi