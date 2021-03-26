//
//  ViewController.swift
//  BoXoB
//
//  Created by Dmitriy Pirko on 26.03.2021.
//

import Foundation


//class ViewController: UIViewController {
//
//    @IBOutlet private var confetiView: CheerView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tabBarController.tabBar.isHidden = true
//        beginGame()
//        applyTheme()
//    }
//
//    deinit {
//        //[super dealloc];
//        //[[_gameLayer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        print("deinit")
//    }
//
//    func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated) // Call the super class implementation.
//        // Usually calling super class implementation is done before self class implementation, but it's up to your application.
//        dismiss(animated: false)
//    }
//
//    func dummyIncreaseLevel() {
//        let levelNumberForStage = UserDefaults.standard.integer(forKey: stage)
//        let overAllLevelNumber = UserDefaults.standard.integer(forKey: "picCross_levelNumber")
//
//        if levelNumber > levelNumberForStage {
//            UserDefaults.standard.set(overAllLevelNumber + 1, forKey: "picCross_levelNumber")
//            UserDefaults.standard.set(levelNumberForStage + 1, forKey: stage)
//            UserDefaults.standard.synchronize()
//        }
//    }
//
//    func beginGame() {
//        confetiView.stop()
//        confetiView.hidden = true
//        levelCompleteView.hidden = true
//
//        levelNumberLbl.text = String(format: "Level: %lu", UInt(levelNumber))
//        puzzleImage = UIImage(named: String(format: "%lu", UInt(levelNumber)))
//        startAfterImageLoad()
//    }
//
//    func applicationDocumentsDirectory() -> String? {
//            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path).last
//        }
//
//        func loadimage() -> UIImage? {
//            let workSpacePath = URL(fileURLWithPath: applicationDocumentsDirectory() ?? "").appendingPathComponent(String(format: "%lu", UInt(levelNumber))).path
//            var image: UIImage? = nil
//            if let data = NSData(contentsOfFile: workSpacePath) {
//                image = UIImage(data: data as Data)
//            }
//
//            return image
//        }
//
//        func startAfterImageLoad() {
//            gameLayer.isUserInteractionEnabled = true
//            //hideNumbering           =   true;
//            hintBtn.enabled = true
//
//
//            level = Level(puzzle: puzzleImage, text: puzzleText)
//            level.emptyTiles = [AnyHashable]()
//
//            var newCells = level.shuffle(gridSize, row: gridSize)
//
//            tileWidth = UIScreen.main.bounds.size.width / (level.numColumns)
//            tileHeight = tileWidth
//
//            gameLayer.frame = CGRect(x: 0, y: view.frame.size.height - ((level.numRows) * tileHeight) - (tileHeight * 1.5), width: (level.numColumns) * tileWidth, height: (level.numRows) * tileHeight)
//            gameLayer.center = CGPoint(x: gameLayer.center.x, y: view.center.y + 20)
//            gameLayer.backgroundColor = UIColor.black
//            gameLayer.layer.borderWidth = 4
//            //_gameLayer.layer.borderColor = [UIColor whiteColor].CGColor;
//            gameLayer.clipsToBounds = true
//            //    [self.view addSubview:_gameLayer];
//            hintBtn.frame = CGRect(x: view.frame.size.width - 75, y: gameLayer.frame.origin.y + gameLayer.frame.size.height + 25, width: 50, height: 50)
//            //[self.hintBtn setBackgroundImage:[UIImage imageNamed:@"btnThemeImg"] forState:UIControlStateNormal];
//
//            addSprites(forCells: newCells)
//        }
//
//}
