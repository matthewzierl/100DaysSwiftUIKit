import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    var noteView: UIView!
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        // Configure noteView
        noteView = UIView()
        noteView.backgroundColor = .systemRed // Example background color
        noteView.layer.cornerRadius = 8
        noteView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(noteView)
        
        // Configure title label
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
        
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
