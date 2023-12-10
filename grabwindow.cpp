#include "grabwindow.h"
#include <QSGTextureProvider>
#include <QDateTime>
#include <QDir>

GrabWindow::GrabWindow(QQuickView &view) :
    m_view(&view),
    m_source(nullptr),
    m_sourceChanged(false),
    encoder(nullptr),
    texId(-1)
{
    m_outputUrl = QUrl::fromLocalFile(QDir::homePath());
    m_outputDir = QDir::toNativeSeparators(QDir::homePath() + "/");
}

GrabWindow::~GrabWindow()
{
    if (encoder)
        delete encoder;
}

void GrabWindow::setSource(QQuickItem *item)
{
    if (item == m_source)
        return;
    m_source = item;
    emit sourceChanged(m_source);
    m_sourceChanged = true;
}

void GrabWindow::setOutputUrl(QUrl url)
{
    if (url == m_outputUrl)
        return;
    m_outputUrl = url;
    m_outputDir = QDir::toNativeSeparators(m_outputUrl.toLocalFile() + "/");
    emit outputUrlChanged(m_outputUrl);
}

void GrabWindow::setOutputDir(QString dir)
{
    if (dir == m_outputDir)
        return;
    m_outputDir = dir;
    emit outputDirChanged(m_outputDir);
}

void GrabWindow::start()
{
    delta = 1;
    performFPSCalculation = true;
    emit countDown(QString::number(3));

    connect(m_view, &QQuickView::afterRendering, this, &GrabWindow::grab, Qt::DirectConnection);
}

void GrabWindow::stop()
{
    disconnect(m_view, &QQuickView::afterRendering, this, &GrabWindow::grab);

    if (encoder)
    {
        delete encoder;
        encoder = nullptr;
    }

    texId = -1;

    times.clear();
    delta = 1;
    performFPSCalculation = false;

    emit countDownEnded();
}

void GrabWindow::initEncoder()
{
    QString preset = "ultrafast";
    int crf = 17;
    m_filename = QDir::toNativeSeparators(m_outputDir + QDateTime::currentDateTime().toString(Qt::ISODate) + ".avi");

    try
    {
        encoder = new Encoder(m_filename.toStdString().c_str(), m_view->width(), m_view->height(), fps, preset.toStdString().c_str(), QString::number(crf).toStdString().c_str(), texId);
    }
    catch (const char* exception)
    {
        std::cout << exception << std::endl;
    }
}

void GrabWindow::grab()
{
    if (m_source)
    {
        if (texId == -1)
        {
            QSGTextureProvider *textureProvider = m_source->textureProvider();
            QSGTexture *texture = textureProvider->texture();
            texId = texture->textureId();
        }
        if (m_sourceChanged && encoder)
        {
            QSGTextureProvider *textureProvider = m_source->textureProvider();
            QSGTexture *texture = textureProvider->texture();
            texId = texture->textureId();
            encoder->setTextureID(texId);
            m_sourceChanged = false;
        }
    }

    if (performFPSCalculation)
    {
        calculateFPS();
    }
    else if (texId >= 0)
    {
      if (!encoder)
            initEncoder();
      if (encoder)
            encoder->recordFrame();
    }
}

void GrabWindow::calculateFPS()
{
    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();
    times.push_back(currentTime);

    if (currentTime >= times[0] + 3000)
    {
        fps = static_cast<int>(times.length() / 3.0);
        times.clear();
        performFPSCalculation = false;
        emit countDownEnded();
    }
    else if ((currentTime - times[0]) / 1000.0 >= delta)
    {
        emit countDown(QString::number(3 - delta));
        delta++;
    }
}
