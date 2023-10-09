//
//  Motivation.swift
//  Motivation
//
//  Created by Rick Curly on 10/9/23.
//

import ScreenSaver

class QuoteScreenSaverView: ScreenSaverView {
    
    var screenNumber: Int = -1
    
    // MARK: - Initialization
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: true)
        
        //implements workaround from https://github.com/JohnCoates/Aerial/issues/1305#issuecomment-1704396149
        // Set a timer callback to delayedInitialize after init is called
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] timer in
            self?.delayedInitialize()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: NSRect) {
        // Guard against drawing before delayed initialization
        guard screenNumber != -1 else { return }
        drawQuote()
    }
    
    private func drawQuote() {
        let text: NSString = "Avada Kedavra"
        let size: CGFloat = min(bounds.width, bounds.height) * 0.1
        let attr = [
            NSAttributedString.Key.font: NSFont(descriptor: NSFontDescriptor(), size: size)!,
            NSAttributedString.Key.foregroundColor: NSColor.white
        ]
        let nsSize = text.size(withAttributes: attr)
        
        text.draw(at: NSPoint(x: bounds.width / 2 - nsSize.width / 2, y: bounds.height / 2 - nsSize.height / 2),
                  withAttributes: attr)
    }
    
    private func delayedInitialize() {
        // Get the screen number using the provided extension method
        screenNumber = NSScreen.getScreenNumber(view: self)
        
        // Call setNeedsDisplay to trigger redrawing after delayed initialization
        setNeedsDisplay(bounds)
    }
}

extension NSScreen {
    class func getScreenNumber(view: NSView) -> Int {
        let screens = NSScreen.screens
        if let windowScreen = view.window?.screen, let index = screens.firstIndex(of: windowScreen) {
            return index
        }
        return -1
    }
}
