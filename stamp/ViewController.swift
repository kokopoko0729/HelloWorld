//
//  ViewController.swift
//  stamp
//
//  Created by ぽこここ on 2016/09/10.
//  Copyright © 2016年 ぽこここ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UITextFieldDelegate,
    UINavigationControllerDelegate {
    
    //スタンプ画像の名前が入った配列
    var imageNameArray: [String] = ["hana","hoshi", "onpu","ラッケト",]
    
    //選択しているスタンプ画像の記号
    var imageIndex: Int = 0
    
    //背景画像を表示させるImageView
    @IBOutlet var haikeiImageView: UIImageView!
    
    //スタンプの画像が入るImageView
    var imageView: UIImageView!
    
    //テキストのラベル
    var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.delegate = self
        
    
        redNumber = CGFloat(sliderR.value)
        greenNumber = CGFloat(sliderG.value)
        blueNumber = CGFloat(sliderB.value)
        
        changeColor()
    }
    var text: String!
    @IBOutlet var textField: UITextField!
    @IBAction func selectedFirst(){
        imageIndex = 1
        
    }
    
    @IBAction func selectedSecond(){
        imageIndex = 2
        
    }
    
    @IBAction func selectedThird(){
        imageIndex = 3
        
    }
    
    @IBAction func selectedFourth(){
        imageIndex = 4
        
    }
    @IBAction func selectedtext(){
        
        imageIndex = 5
        text = textField.text
    
    
    }
    @IBAction func clear(){
        while imageArray.count != 0 {
            let image = self.imageArray.popLast()
            image?.removeFromSuperview()
        }
        while labelArray.count != 0 {
            let label = self.labelArray.popLast()
            label?.removeFromSuperview()
        }
    }
    
    var redNumber:CGFloat!
    var greenNumber:CGFloat!
    var blueNumber:CGFloat!
    
    @IBOutlet weak var sliderR: UISlider!
    @IBOutlet weak var sliderG: UISlider!
    @IBOutlet weak var sliderB: UISlider!
    
    
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBAction func redslider(sender: AnyObject) {
        redNumber = CGFloat(sliderR.value)
        changeColor()
    }
    
    @IBAction func greenslider(sender: AnyObject) {
        greenNumber = CGFloat(sliderG.value)
        changeColor()
    }
    @IBAction func blueslider(sender: AnyObject) {
        blueNumber = CGFloat(sliderB.value)
        changeColor()
    }
    
    func changeColor(){
        colorLabel.backgroundColor = UIColor(red:redNumber,
                                             green: greenNumber,blue:
            blueNumber,alpha: 1.0)
    }
    var imageArray: [UIImageView] = []
    var labelArray: [UILabel] = []
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      //タッチされた位置を取得
        let touch: UITouch = (touches.first)!
        let location: CGPoint = touch.locationInView(self.view)
        
        //もしimageIndexが0でない(オススタンプが選ばれていない)とき
        if imageIndex != 0 {
                            if imageIndex == 5 {
                                let textcount:CGFloat = CGFloat(text.characters.count) * 20
                    //ラベルを作る
                    label = UILabel(frame: CGRectMake(0,50,textcount,100))
                    label.text = text
                    label.layer.position = CGPoint(x:location.x,y: location.y)
//                                label.textColor = UIColor(red: redNumber,
//                                                          green:  greenNumber,blue:  blueNumber,alpha: 1,0)
                                label.textColor = UIColor(red:redNumber,green: greenNumber,
                                                                     blue:blueNumber,alpha: 1.0)

                    self.view.addSubview(label)
                    print(text.characters.count)
                    labelArray.append(label)
                                
                            
                }else { //スタンプサイズを40pxの正方形に指定
                imageView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
                
                //押されたスタンプの画像を設定
                let image: UIImage = UIImage(named:imageNameArray[imageIndex - 1])!
                imageView.image = image
                
                //タッチされた位置に画像をおく
                imageView.center = CGPointMake(location.x, location.y)
                
                //画面に表示する
                self.view.addSubview(imageView)
                imageArray.append(imageView)
                
            }
        }
    }
    
    @IBAction func back(){
        if imageIndex == 0 {
            return
        }
        if imageIndex < 5 {
            let image = self.imageArray.popLast()
            image?.removeFromSuperview()
         
        }else {
        let label = self.labelArray.popLast()
            label?.removeFromSuperview()
        }
        
    }
    
    @IBAction func selectBackground() {
        //UIImagePickerControllerのインスタンスを作る
        let imagePickerContoroller: UIImagePickerController = UIImagePickerController()
        
        //フォトライブラリを使う設定をする
        imagePickerContoroller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerContoroller.delegate = self
        imagePickerContoroller.allowsEditing = true
        
        //フォトライブラリを呼び出す
        self.presentViewController(imagePickerContoroller, animated: true, completion:
            nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        //フォトライブラリから画像の選択が終わったら呼ばれるメソッド
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
            [String : AnyObject]) {
            
            //imageに選んだ画像を設定する
            let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            //そのimageを背景に設定する
            haikeiImageView.image = image
            
            //フォトライブラリを閉じる
            picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
        @IBAction func save() {
            //画面のスクリーンショットを取得
            let rect: CGRect = CGRectMake(0, 30, 320, 380)
            UIGraphicsBeginImageContext(rect.size)
            self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let capture = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
    
            //フォトライブラリに保存
            UIImageWriteToSavedPhotosAlbum(capture, nil, nil, nil)
            let alert = UIAlertController(title: "保存",
                        message: "保存完了！",
                        preferredStyle:  UIAlertControllerStyle.Alert)
        alert.addAction(
                  UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler: {action in
                        //ボタンが押された時の動作
                        NSLog("OKボタンが押されました！")
                    }
                    ))
                        presentViewController(alert, animated: true, completion: nil)
                        
            
    }
}







