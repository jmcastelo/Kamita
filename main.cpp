#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickView>
#include "grabwindow.h"
#include "filereader.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    const QUrl url(QStringLiteral("qrc:/Main.qml"));

    QQuickView view;

    FileReader fileReader;
    view.engine()->rootContext()->setContextProperty("fileReader", &fileReader);

    GrabWindow grabWindow(view);
    view.engine()->rootContext()->setContextProperty("grabWindow", &grabWindow);

    view.setSource(url);
    view.setTitle("Kamita");
    view.setFlags(Qt::Window | Qt::WindowSystemMenuHint | Qt::WindowTitleHint | Qt::WindowMinMaxButtonsHint | Qt::WindowCloseButtonHint);
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();

    return app.exec();
}
