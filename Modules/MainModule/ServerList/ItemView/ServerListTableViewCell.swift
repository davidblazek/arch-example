//
//  ServerListTableViewCell.swift
//  AppCore
//

import UIKit

public class ServerListTableViewCell: UITableViewCell {

    internal let itemView = ServerListItemView.loadFromNib()
    
    internal required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init() {
        super.init(style: .default, reuseIdentifier: ServerListTableViewCell.cellIdentifier)

        setupContentView()
    }
    
    override internal init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupContentView()
    }

    private func setupContentView() {
        contentView.addSubview(itemView)
        itemView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        itemView.topContentView.backgroundColor = highlighted ? Color.disabled.color.withAlphaComponent(0.3) : Color.background.color
    }
}

extension ServerListTableViewCell {

    internal func configure(data: VPNProfileModel?) {
        itemView.configure(data: data)
    }
}
