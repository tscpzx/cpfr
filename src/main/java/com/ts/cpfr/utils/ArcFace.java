package com.ts.cpfr.utils;

import com.arcsoft.face.EngineConfiguration;
import com.arcsoft.face.FaceEngine;
import com.arcsoft.face.FunctionConfiguration;

import java.awt.color.ColorSpace;
import java.awt.image.BufferedImage;
import java.awt.image.ColorConvertOp;
import java.awt.image.DataBufferByte;
import java.io.ByteArrayInputStream;
import java.io.IOException;

import javax.imageio.ImageIO;

/**
 * @Classname ArcFace
 * @Description
 * @Date 2019/3/13 14:37
 * @Created by cjw
 */
public class ArcFace {
    private ArcFace() {
        FaceEngine faceEngine = ArcFaceInstance.FACE_ENGINE;
        //激活引擎
        faceEngine.active(SystemConfig.ARCSOFT_APPID, SystemConfig.ARCSOFT_SDKKEY);

        EngineConfiguration engineConfiguration = EngineConfiguration.builder().functionConfiguration(
          FunctionConfiguration.builder()
            .supportAge(true)
            .supportFace3dAngle(true)
            .supportFaceDetect(true)
            .supportFaceRecognition(true)
            .supportGender(true)
            .build()).build();
        //初始化引擎
        faceEngine.init(engineConfiguration);
    }

    private static class ArcFaceInstance {
        private static final FaceEngine FACE_ENGINE = new FaceEngine();
        private static final ArcFace ARC_FACE = new ArcFace();
    }

    public static ArcFace getArcFace() {
        return ArcFaceInstance.ARC_FACE;
    }

    public static FaceEngine getFaceEngine() {
        return ArcFaceInstance.FACE_ENGINE;
    }

    public ImageInfo getRGBData(byte[] bytes) {
        if (bytes == null)
            return null;
        ImageInfo imageInfo;
        try {
            //将图片文件加载到内存缓冲区
            BufferedImage image = ImageIO.read(new ByteArrayInputStream(bytes));
            imageInfo = bufferedImage2ImageInfo(image);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
        return imageInfo;
    }

    private ImageInfo bufferedImage2ImageInfo(BufferedImage image) {
        ImageInfo imageInfo = new ImageInfo();
        int width = image.getWidth();
        int height = image.getHeight();
        // 使图片居中
        width = width & (~3);
        height = height & (~3);
        imageInfo.width = width;
        imageInfo.height = height;
        //根据原图片信息新建一个图片缓冲区
        BufferedImage resultImage = new BufferedImage(width, height, image.getType());
        //得到原图的rgb像素矩阵
        int[] rgb = image.getRGB(0, 0, width, height, null, 0, width);
        //将像素矩阵 绘制到新的图片缓冲区中
        resultImage.setRGB(0, 0, width, height, rgb, 0, width);
        //进行数据格式化为可用数据
        BufferedImage dstImage = new BufferedImage(image.getWidth(), image.getHeight(), BufferedImage.TYPE_3BYTE_BGR);
        if (resultImage.getType() != BufferedImage.TYPE_3BYTE_BGR) {
            ColorSpace cs = ColorSpace.getInstance(ColorSpace.CS_LINEAR_RGB);
            ColorConvertOp colorConvertOp = new ColorConvertOp(cs, dstImage.createGraphics().getRenderingHints());
            colorConvertOp.filter(resultImage, dstImage);
        } else {
            dstImage = resultImage;
        }

        //获取rgb数据
        imageInfo.rgbData = ((DataBufferByte) (dstImage.getRaster().getDataBuffer())).getData();
        return imageInfo;
    }


    public class ImageInfo {
        private byte[] rgbData;
        private int width;
        private int height;

        public byte[] getRgbData() {
            return rgbData;
        }

        public void setRgbData(byte[] rgbData) {
            this.rgbData = rgbData;
        }

        public int getWidth() {
            return width;
        }

        public void setWidth(int width) {
            this.width = width;
        }

        public int getHeight() {
            return height;
        }

        public void setHeight(int height) {
            this.height = height;
        }
    }
}
