<?php
namespace app\controllers;

use Yii;
use yii\web\Controller;
use Prometheus\CollectorRegistry;
use Prometheus\RenderTextFormat;
use Prometheus\Storage\InMemory; // For production, use Redis or APC

class MetricsController extends Controller
{
    public function actionIndex()
    {
        $registry = new CollectorRegistry(new InMemory()); // Use Redis for multi-process
        $renderer = new RenderTextFormat();

        // Example: increment a counter
        $counter = $registry->getOrRegisterCounter('app', 'requests_total', 'Total requests');
        $counter->inc();

        $metrics = $registry->getMetricFamilySamples();
        Yii::$app->response->format = \yii\web\Response::FORMAT_RAW;
        Yii::$app->response->headers->set('Content-Type', RenderTextFormat::MIME_TYPE);
        return $renderer->render($metrics);
    }
}
