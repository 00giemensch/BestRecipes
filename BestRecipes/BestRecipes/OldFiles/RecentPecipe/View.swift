//import UIKit
//
//// MARK: - Recipe Cell
//class RecipeItemCell: UICollectionViewCell {
//    static let reuseId = "RecipeItemCell"
//
//    private let imageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
//        iv.layer.cornerRadius = 12 
//        iv.clipsToBounds = true
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        return iv
//    }()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Poppins-SemiBold", size: 14)
//        label.textColor = UIColor(named: "Neutral100") ?? UIColor(hex: 0x181A2A)
//        label.numberOfLines = 2
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let subtitleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Poppins-Regular", size: 10)
//        label.textColor = UIColor(named: "Neutral50") ?? UIColor(hex: 0x919191)
//        label.numberOfLines = 1
//        label.lineBreakMode = .byTruncatingTail
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//
//    private func setupUI() {
//        contentView.addSubview(imageView)
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(subtitleLabel)
//
//        NSLayoutConstraint.activate([
//            // Фото
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: 124),
//            imageView.heightAnchor.constraint(equalToConstant: 124),
//            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//
//            // Заголовок
//            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
//            titleLabel.heightAnchor.constraint(equalToConstant: 40),
//
//            // Подзаголовок
//            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
//            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
//            subtitleLabel.widthAnchor.constraint(equalToConstant: 99),
//            subtitleLabel.heightAnchor.constraint(equalToConstant: 14)
//        ])
//    }
//
//    func setupRecipe(_ recipe: RecipeModel) {
//            titleLabel.text = recipe.title
//            subtitleLabel.text = recipe.creditsText.isEmpty ? "Unknown Author" : recipe.creditsText
//
//            NetworkManager.shared.loadImage(from: recipe.image) { [weak self] result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let image):
//                        self?.imageView.image = image
//                    case .failure:
//                        self?.imageView.image = UIImage(named: "defaultSearch")
//                    }
//                }
//            }
//        }
//    
//
//}
//
//
//
//
//// MARK: - Main View Controller
//class RecipesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
//
//    let presenter = RecipesPresenter()
//
//    let blockTitleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Recent recipe"
//        label.font = UIFont(name: "Poppins-SemiBold", size: 20)
//        label.textColor = UIColor(named: "Neutral100") ?? UIColor(hex: 0x181A2A)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let seeAllButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("See all →", for: .normal)
//        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 14)
//        button.setTitleColor(UIColor(named: "Primary50") ?? UIColor(hex: 0xFD5B44), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(nil, action: #selector(seeAllTapped), for: .touchUpInside)
//        return button
//    }()
//
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: 124, height: 190)
//        layout.minimumLineSpacing = 16
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.dataSource = self
//        cv.delegate = self
//        cv.register(RecipeItemCell.self, forCellWithReuseIdentifier: RecipeItemCell.reuseId)
//        cv.backgroundColor = .systemBackground
//        cv.showsHorizontalScrollIndicator = false
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        return cv
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        setupUI()
//    }
//
//    func setupUI() {
//        view.addSubview(blockTitleLabel)
//        view.addSubview(seeAllButton)
//        view.addSubview(collectionView)
//
//        NSLayoutConstraint.activate([
//            blockTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            blockTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            blockTitleLabel.heightAnchor.constraint(equalToConstant: 28),
//
//            seeAllButton.centerYAnchor.constraint(equalTo: blockTitleLabel.centerYAnchor),
//            seeAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            seeAllButton.widthAnchor.constraint(equalToConstant: 71),
//            seeAllButton.heightAnchor.constraint(equalToConstant: 20),
//
//            collectionView.topAnchor.constraint(equalTo: blockTitleLabel.bottomAnchor, constant: 16),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.heightAnchor.constraint(equalToConstant: 190)
//        ])
//    }
//
//    @objc func seeAllTapped() {
//        print("See all tapped")
//    }
//
//    func showRecipeDetail(for recipe: RecipeModel) {
//        let detailVC = RecipeDetailViewController(recipe: recipe)
//        navigationController?.pushViewController(detailVC, animated: true)
//    }
//
//
//    // --- UICollectionViewDataSource ---
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        presenter.recipes.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeItemCell.reuseId, for: indexPath) as? RecipeItemCell else {
//            return UICollectionViewCell()
//        }
//        cell.setupRecipe(presenter.recipes[indexPath.item])
//        return cell
//    }
//
//    // --- UICollectionViewDelegate ---
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedRecipe = presenter.recipes[indexPath.item]
//        showRecipeDetail(for: selectedRecipe)
////        print("\(selectedRecipe)")
////        print("\(showRecipeDetail(for: selectedRecipe))")
//    }
//}
//// MARK: - Пример контроллера деталей рецепта
////class RecipeDetailViewController: UIViewController {
////    let recipe: Recipe
////
////    init(recipe: Recipe) {
////        self.recipe = recipe
////        super.init(nibName: nil, bundle: nil)
////    }
////    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        view.backgroundColor = .systemBackground
////        title = recipe.title
////    }
////}
