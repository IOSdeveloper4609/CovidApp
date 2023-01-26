//
//  AutolayoutUtils.swift
//  apicovidtest
//
//  Created by Azat Kirakosyan on 22.10.2021.
//

import UIKit

extension UIView {
    
    /// Привязка верхней точки View к нижней точке указанного View
    /// - Parameters:
    ///   - view: к низу которого привязываем
    ///   - spacing: рассточние между элементами
    ///   - priority: установка приоритетов, по умолчанию .required
    func pinTop(toBottom view: UIView,
                spacing: CGFloat = 0,
                priority: UILayoutPriority = .required) {
        assert(self.superview == view.superview, "Use only for views with common superview")
        self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: spacing).activate()
    }
    
    /// Установка и активация констрейнтов относительно родительской View
    /// - Parameters:
    ///   - edges: что привязываем, по умолчанию все стороны
    ///   - insets: отступы, по умолчанию отступы = 0
    ///   - safeArea: учитывать SafeArea или нет, по умолчанию не учитвается
    ///   - priority: установка приоритетов, по умолчанию .required
    func pinToSuperview(edges: UIRectEdge = .all,
                        insets: UIEdgeInsets = .zero,
                        safeArea: Bool = false,
                        priority: UILayoutPriority = .required) {
        guard let view = self.superview else {
            assertionFailure("View must have superview")
            return
        }
        self.pin(to: view, edges: edges, insets: insets, safeArea: safeArea, priority: priority)
    }
    
    
    /// Установка и активация констрейнтов относительно указанной оси
    /// - Parameters:
    ///   - view: к какой View привязываем
    ///   - axis: ось координат
    ///   - offset: offset
    ///   - priority: установка приоритетов, по умолчанию .required
    func pinCenter(to view: UIView,
                   of axis: NSLayoutConstraint.Axis,
                   offset: CGPoint = .zero,
                   priority: UILayoutPriority = .required) {
        switch axis {
        case .horizontal:
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x).activate(priority: priority)
        case .vertical:
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y).activate(priority: priority)
        @unknown default:
            fatalError()
        }
    }
    
    /// Установка и активация констрейнтов относительно указанной оси для superview
    /// - Parameters:
    ///   - view: к какой View привязываем
    ///   - axis: ось координат
    ///   - offset: offset
    ///   - priority: установка приоритетов, по умолчанию .required
    func pinCenterToSuperview(of axis: NSLayoutConstraint.Axis, offset: CGPoint = .zero, priority: UILayoutPriority = .required) {
        guard let superview = self.superview else {
            assertionFailure("View must have superview")
            return
        }
        self.pinCenter(to: superview, of: axis, offset: offset, priority: priority)
    }
    
    /// Установка и активация констрйента высоты
    /// - Parameters:
    ///   - height: высота
    ///   - priority: приоритет
    func pin(height: CGFloat, priority: UILayoutPriority = .required) {
        self.heightAnchor.constraint(equalToConstant: height).activate(priority: priority)
    }
    
    /// Установка и активация констрйентов для размеров View
    /// - Parameters:
    ///   - size: устанавливаемые размеры
    ///   - priority: установка приоритетов, по умолчанию .required
    func pin(size: CGSize, priority: UILayoutPriority = .required) {
        [self.widthAnchor.constraint(equalToConstant: size.width),
         self.heightAnchor.constraint(equalToConstant: size.height)].activate(priority: priority)
    }
    /// Установка и активация констрейнтов относительно родительской View
    /// - Parameters:
    ///   - view: относительно какой View устанавливаем констрейнты
    ///   - edges: что привязываем, по умолчанию все стороны
    ///   - insets: отступы, по умолчанию отступы = 0
    ///   - safeArea: учитывать SafeArea или нет, по умолчанию не учитвается
    ///   - priority: установка приоритетов, по умолчанию .required
    func pin(to view: UIView,
             edges: UIRectEdge = .all,
             insets: UIEdgeInsets = .zero,
             safeArea: Bool = false,
             priority: UILayoutPriority = .required) {
        if #available(iOS 11.0, *) {
            let constraints: [NSLayoutConstraint] = .init { () -> [NSLayoutConstraint] in
                if edges.contains(.left) {
                        self.leadingAnchor.constraint(equalTo: safeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor, constant: insets.left)
                }
                if edges.contains(.top) {
                    
                        self.topAnchor.constraint(equalTo: safeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, constant: insets.top)
                }
                if edges.contains(.right) {
                    (safeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor).constraint(equalTo: self.trailingAnchor, constant: insets.right)
                }
                if edges.contains(.bottom) {
                    (safeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor).constraint(equalTo: self.bottomAnchor, constant: insets.bottom)
                }
            }
            constraints.activate(priority: priority)
        } else {
            let constraints: [NSLayoutConstraint] = .init { () -> [NSLayoutConstraint] in
                if edges.contains(.left) {
                    self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left)
                }
                if edges.contains(.top) {
                    self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top)
                }
                if edges.contains(.right) {
                    view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: insets.right)
                }
                if edges.contains(.bottom) {
                    view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: insets.bottom)
                }
            }
            constraints.activate(priority: priority)
        }
    }
    
}

public extension UIEdgeInsets {
    
    init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        self = .init(top: top, left: leading, bottom: bottom, right: trailing)
    }

    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self = .init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    init(all: CGFloat = 0) {
        self = .init(top: all, left: all, bottom: all, right: all)
    }

    static func all(_ value: CGFloat = 0) -> UIEdgeInsets {
        UIEdgeInsets(all: value)
    }

    static func vertical(_ value: CGFloat = 0) -> UIEdgeInsets {
        UIEdgeInsets(vertical: value)
    }
}

public extension NSLayoutConstraint {
    func activate(priority: UILayoutPriority = .required) {
        self.priority = priority
        self.isActive = true
    }
}


@_functionBuilder
public enum ConstraintsBuilder {
    public static func buildBlock(_ constraints: [NSLayoutConstraint]...) -> [NSLayoutConstraint] {
        constraints.flatMap { $0 }
    }

    public static func buildIf(_ constraints: [NSLayoutConstraint]?) -> [NSLayoutConstraint] {
        constraints ?? []
    }

    public static func buildExpression(_ constraint: NSLayoutConstraint?) -> [NSLayoutConstraint] {
        guard let constraint = constraint else { return [] }
        return [constraint]
    }

    public static func buildExpression(_ constraint: NSLayoutConstraint) -> [NSLayoutConstraint] {
        [constraint]
    }
}

public extension Array where Element == NSLayoutConstraint {
    
    init(@ConstraintsBuilder _ builder: () -> [NSLayoutConstraint]) {
        self = builder()
    }
    
    func activate(priority: UILayoutPriority = .required) {
        self.forEach { $0.activate(priority: priority) }
    }
    
}
