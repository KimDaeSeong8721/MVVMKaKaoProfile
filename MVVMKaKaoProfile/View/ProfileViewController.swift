//
//  ProfileViewController.swift
//  KakaoProfile
//
//  Created by DaeSeong on 2022/07/09.
//

import UIKit
import RxSwift
import RxCocoa


class ProfileViewController: BaseViewController,ViewModelBindableType {

    // MARK: - Properties
    var viewTranslation = CGPoint(x: 0, y: 0)
    var viewVelocity = CGPoint(x: 0, y: 0)

    var viewModel: ProfileViewModel!
    private var panGesture = UIPanGestureRecognizer()
    private let  dismissButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "profileCloseBtn"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 30
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight : .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    private let subLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight : .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let horizontalLine : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var firstButton: UIView = {
       let view = ImageLabelView(symbolName: "profileTalkImg",
                                 textLabel: "나와의 채팅")
        return view
    }()
    private lazy var secondButton: UIView = {
        let view = ImageLabelView(symbolName: "profileEditImg",
                                  textLabel: "프로필 편집")
        return view
    }()
    private lazy var thirdButton: UIView = {
        let view = ImageLabelView(symbolName: "profileStoryImg",
                                  textLabel: "카카오스토리")
        return view
    }()
    
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 62
        return stackView
    }()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func render() {

        view.addSubview(dismissButton)

        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.height.equalTo(44)
        }
        view.addSubview(profileImageView)

        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(512)
            make.width.height.equalTo(100)
        }
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
        }

        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }

        view.addSubview(horizontalLine)
        horizontalLine.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(27)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        view.addSubview(stackView)
        stackView.addArrangedSubview(firstButton)
        stackView.addArrangedSubview(secondButton)
        stackView.addArrangedSubview(thirdButton)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(horizontalLine.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(53)
        }
    }

    override func configUI() {
        view.backgroundColor = .systemGray
        view.addGestureRecognizer(panGesture)
    }

    func bind() {

        let input = ProfileViewModel.Input(dismissTapped: dismissButton.rx.tap,
                                           secondButtonTapped: secondButton.rx.tapGesture)

        let output = viewModel.transform(input: input)

        output.dismissTapped
            .subscribe(onNext:{
                self.dismiss(animated: true)
            })
            .disposed(by: viewModel.disposeBag)

        output.secondButtonTapped
            .subscribe(onNext: {
                var vc = MChangeViewController()
                vc.bindViewModel(self.viewModel)
                self.present(vc, animated: true)

            })
            .disposed(by: viewModel.disposeBag)

        output.information
            .subscribe(onNext: { info in
                self.profileImageView.image = UIImage(named: info.imageName)
                self.nameLabel.text = info.name
                self.subLabel.text = info.subTitle
            })
            .disposed(by: viewModel.disposeBag)


        panGesture.rx.event
            .subscribe { gesture in
                let sender = gesture.element!
                self.configPanGesture(sender)
            }
            .disposed(by: viewModel.disposeBag)

    }

// MARK: - Func


private func configPanGesture(_ sender: UIPanGestureRecognizer) {
    viewTranslation = sender.translation(in: self.view) // 뷰가 이동한 위치 저장
    viewVelocity = sender.velocity(in: self.view) //view가 이동한 방향 저장

    switch sender.state {
    case .changed:
        // 상하로 스와이프 할 때 위로 스와이프가 안되게 해주기 위해서 조건 설정
        if viewVelocity.y > 0 {
            UIView.animate(withDuration: 0.1, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        }
    case .ended:
        // 해당 뷰의 y값이 400보다 작으면(작게 이동 시) 뷰의 위치를 다시 원상복구하겠다. = 즉, 다시 y=0인 지점으로 리셋
        if viewTranslation.y < 400 {
            UIView.animate(withDuration: 0.1, animations: {
                self.view.transform = .identity
            })
            // 뷰의 값이 400 이상이면 해당 화면 dismiss
        } else {
            dismiss(animated: true, completion: nil)
        }
        // 추가로 아래쪽 스와이프의 속도가 초당 300보다 크면 화면 dismiss
        if viewVelocity.y > 300 {
            dismiss(animated: true, completion: nil)
        }

    default:
        break
    }
}
}
 // MARK: - Extension

extension Reactive where Base: UIView {
public var tapGesture : ControlEvent<UITapGestureRecognizer> {
        self.base.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer()
        self.base.addGestureRecognizer(gesture)
        return gesture.rx.event
    }
}

