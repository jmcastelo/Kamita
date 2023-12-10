#ifndef GRABWINDOW_H
#define GRABWINDOW_H

//#include <QtQml/qqml.h>
#include "encoder.h"
#include <QQuickItem>
#include <QQuickView>
#include <QUrl>

class GrabWindow: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQuickItem *source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString outputDir READ outputDir WRITE setOutputDir NOTIFY outputDirChanged)
    Q_PROPERTY(QUrl outputUrl READ outputUrl WRITE setOutputUrl NOTIFY outputUrlChanged)

public:
    GrabWindow(QQuickView &view);
    ~GrabWindow();

    QQuickItem *source() const { return m_source; }
    void setSource(QQuickItem *item);

    QString outputDir() const { return m_outputDir; }
    void setOutputDir(QString dir);

    QUrl outputUrl() const { return m_outputUrl; }
    void setOutputUrl(QUrl url);

    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();

signals:
    void sourceChanged(QQuickItem *item);
    void outputUrlChanged(QUrl url);
    void outputDirChanged(QUrl dir);
    void countDown(QString time);
    void countDownEnded();

private:
    QQuickView *m_view;
    QQuickItem *m_source;
    bool m_sourceChanged;
    QUrl m_outputUrl;
    QString m_outputDir;
    QString m_filename;
    Encoder *encoder;
    int texId;
    int fps;
    QVector<qint64> times;
    int delta;
    bool performFPSCalculation;

    void calculateFPS();
    void initEncoder();

private slots:
    void grab();

};

#endif // GRABWINDOW_H
