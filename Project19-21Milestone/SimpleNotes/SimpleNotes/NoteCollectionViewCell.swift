import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    var noteView: UIView!
    var title: UILabel!
    
    var notSelectedImage: UIImageView!
    var selectedImage: UIImageView!
    var isEditMode = false {
        didSet {
            if isEditMode {
                notSelectedImage.isHidden = false
            } else {
                notSelectedImage.isHidden = true
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditMode == false { return }
            notSelectedImage.isHidden = isSelected
            selectedImage.isHidden = !isSelected
            if isSelected {
                noteView.layer.borderWidth = 3
            } else {
                noteView.layer.borderWidth = 0
            }
        }
    }
    
    
    private func setupViews() {
        // Configure noteView
        noteView = UIView()
        noteView.backgroundColor = .systemRed // Example background color
        noteView.layer.cornerRadius = 8
        noteView.translatesAutoresizingMaskIntoConstraints = false
        noteView.layer.borderWidth = 0
        noteView.layer.borderColor = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
        contentView.addSubview(noteView)
        
        // Configure title label
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
        
        // Configure selection overlays
        notSelectedImage = UIImageView(image: UIImage(systemName: "circle"))
        notSelectedImage.isHidden = true // Initially hidden
        notSelectedImage.layer.position = CGPoint(x: 57.5, y: 90)
        contentView.addSubview(notSelectedImage)
        
        
        selectedImage = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        selectedImage.isHidden = true
        selectedImage.layer.position = CGPoint(x: 57.5, y: 90)
        contentView.addSubview(selectedImage)
        
        
        // Set up constraints for noteView
        NSLayoutConstraint.activate([
            noteView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            noteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            noteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            noteView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7)
        ])
        
        // Set up constraints for title
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: noteView.bottomAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
    }
}
