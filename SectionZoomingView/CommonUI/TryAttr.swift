//
//  TryAttr.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 3/21/23.
//

import SwiftUI


struct AttributedConverted: View {
    var defaultText: String
    func prependedText(_ pre: String) -> String {
        return pre + "\n\n" + self.defaultText
    }
    var body: some View {
        VStack(spacing: 16.0) {
            GeometryReader { proxy in
                OTAttLabel(theText: self.prependedText("att label text"), framex: proxy.frame(in: .local))

            }

            Text(self.prependedText("Default SwiftUI: .system(14)"))
                .font(Font(uiFont: .otf_systemFontOfSize(14)))
                .foregroundColor(.ash_dark)
            Text(AttributedString(self.prependedText("SwiftUI Text(AttString(_ nsAttstring))): .system(14)").otKit_attributedStringApplyingOTKitLineHeight(.systemFont(ofSize: 14), textColor: .otk_ashDark)))
            Text(self.prependedText("otk_configure .system(14)"))
                .otk_configureBodyText(fontSize: 14)
                .foregroundColor(.ash_dark)
        }


    }
}

fileprivate extension Color {
    private static func someRandomColors() -> [Color] {
        [.otk_purple, .otk_blue, .otk_green, .otk_orange]
    }

    // Stable random color for a string based on its hash
    static func pseudoRandom(for string: String) -> Color {
        let colors = someRandomColors()
        let i = abs(string.hashValue) % colors.count
        return colors[i]
    }
}

struct AttributedConverted_Previews: PreviewProvider {
    static var string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nulla lorem nullam.llorem Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus sagittis nulla ut leo sodales, nec facilisis quam condimentum. Phasellus et ultrices diam. Mauris ornare hendrerit eros ac tempor. Praesent consequat, mi feugiat aliquam egestas, magna est suscipit tellus"
    static var previews: some View {
        AttributedConverted(defaultText: Self.string)
    }
}

class AttHosting: UIHostingController<AttributedConverted> {
    var string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nulla lorem nullam.llorem Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus sagittis nulla ut leo sodales, nec facilisis quam condimentum. Phasellus et ultrices diam. Mauris ornare hendrerit eros ac tempor. Praesent consequat, mi feugiat aliquam egestas, magna est suscipit tellus"

    required init?(coder aDecoder: NSCoder) {
        super.init(rootView: AttributedConverted(defaultText: self.string))
    }
}

class AttHostHostVC: UIViewController {
    var string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nulla lorem nullam.llorem Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus sagittis nulla ut leo sodales, nec facilisis quam condimentum. Phasellus et ultrices diam. Mauris ornare hendrerit eros ac tempor. Praesent consequat, mi feugiat aliquam egestas, magna est suscipit tellus"

    @IBOutlet var attLabel: UILabel?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let updated = "UIKit .system(14)\n\n" + self.string
        self.attLabel?.font = UIFont.otf_systemFontOfSize(14)
        self.attLabel?.attributedText = updated.otKit_attributedStringApplyingOTKitLineHeight(.otf_systemFontOfSize(14), textColor: .otk_ashDark)
    }
}


extension String {
    public func otKit_attributedStringApplyingOTKitLineHeight(_ font: UIFont?, textColor: UIColor, centerText: Bool = false) -> NSAttributedString {
        // the string cannot be empty
        guard self.isEmpty == false,
              let font = font
        else { return NSAttributedString(string: self) }

        let paragraphStyle = NSParagraphStyle.otKit_Paragraph(with: font, linebreak: .byWordWrapping, centered: centerText)

        return NSAttributedString(string: self, attributes: [.font: font, .paragraphStyle: paragraphStyle, .foregroundColor: textColor])
    }
}


struct OTAttLabel: UIViewRepresentable {
    var theText: String
    var framex: CGRect = .zero

    func makeUIView(context: Context) -> UILabel {
        let v = UILabel()
        v.attributedText = self.theText.otKit_attributedStringApplyingOTKitLineHeight(.otf_systemFontOfSize(14), textColor: .otk_ashDark)
        v.font = .otf_systemFontOfSize(14)
        v.numberOfLines = 0
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.widthAnchor.constraint(equalToConstant: self.framex.width).isActive = true
        v.setContentHuggingPriority(.defaultHigh, for: .vertical)
        v.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        v.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        v.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)


        return v
    }

    func updateUIView(_ label: UILabel, context: Context) {
        label.attributedText = self.theText.otKit_attributedStringApplyingOTKitLineHeight(.otf_systemFontOfSize(14), textColor: .otk_ashDark)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UILabel, context: Context) -> CGSize? {
        print(proposal)
        let prop = CGSize(width: proposal.width!, height: 10000)
        print(uiView.sizeThatFits(CGSize(width: proposal.width!, height: 10000)))
        let aaa = self.theText.otKit_attributedStringApplyingOTKitLineHeight(.otf_systemFontOfSize(14), textColor: .otk_ashDark)
        print("ddddddd")
        let theHeight = self.theText.otf_boundingHeight(within: prop.width, font: .otf_systemFontOfSize(14))
        print(theHeight)
        print(aaa.boundingRect(with: prop, options: .usesFontLeading, context: nil))
        return CGSize(width: proposal.width!, height: theHeight)
    }
}
extension String {

public func otf_boundingHeight(within width: CGFloat, font: UIFont?) -> CGFloat {
    let font = font ?? UIFont.otf_systemFontOfSize(UIFont.systemFontSize)
    let paragraphStyle = NSParagraphStyle.otKit_Paragraph(with: font, linebreak: .byWordWrapping, centered: false)

    return self.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                             options: [.usesLineFragmentOrigin, .usesFontLeading],
                             attributes: [.font : font.otf_adjustedFont(), .paragraphStyle: paragraphStyle],
                             context: nil).height
    }
}
