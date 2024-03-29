//
//  PaywallView.swift
//  MyTradingJournal
//
//  Created by James Sedlacek on 11/22/22.
//

import SwiftUI

struct PaywallViewViewModel {
    let title: String
    let subtitle: String
    let delegate: PaywallViewDelegate?
}

protocol PaywallViewDelegate {
    func didTapRestorePurchase()
    func didTapPurchase(plan: PremiumPlan)
}

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: PremiumPlan = .yearly
    let iPhone14ProMaxScreenSize: CGSize = CGSize(width: 430.0, height: 932.0)
    let screenSize: CGSize = UIScreen.main.bounds.size
    let viewModel: PaywallViewViewModel
    
    init(viewModel: PaywallViewViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
            VStack(alignment: .center, spacing: 16) {
                headerSection()
                carouselSection()
                choosePlanSection()
                actionButton()
                restorePurchasesButton()
            }
            // To make the view 'responsive' we scale it down from an iPhone14ProMax's size
            // Note: This is a temporary 'hack' that will not work for all device types
            .scaleEffect(CGSize(width: screenSize.width / iPhone14ProMaxScreenSize.width,
                                height: screenSize.height / iPhone14ProMaxScreenSize.height))
            .padding(.horizontal, isIPhone14ProMax() ? 0 : -20)
            .animation(.spring(), value: selectedPlan)
        }
    }
    
    private func headerSection() -> some View {
        return VStack {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(viewModel.title)
                            .font(.system(size: 26, weight: .semibold))
                        Spacer()
                        XMarkButton() { dismiss() }
                    }
                    Text(viewModel.subtitle)
                        .font(.system(size: 40, weight: .bold))
                }
                Spacer()
            }
        }.padding(20)
    }
    
    private func carouselSection() -> some View {
        return VStack {
            InfiniteScroller(contentWidth: getContentWidth(), direction: .forward) {
                HStack(spacing: 16) {
                    FeatureCardView(featureCard: .unlimitedEntries)
                    FeatureCardView(featureCard: .importData)
                    FeatureCardView(featureCard: .biometricsLock)
                    FeatureCardView(featureCard: .automaticBackups)
                }.padding(8)
            }
            
            InfiniteScroller(contentWidth: getContentWidth(), direction: .backward) {
                HStack(spacing: 16) {
                    FeatureCardView(featureCard: .customTags)
                    FeatureCardView(featureCard: .moreStats)
                    FeatureCardView(featureCard: .moreDates)
                    FeatureCardView(featureCard: .unlimitedGoals)
                }.padding(8)
            }
        }
    }
    
    private func choosePlanSection() -> some View {
        return VStack(alignment: .center, spacing: 16) {
            Text("Choose a plan")
                .foregroundColor(.secondary)
                .font(.system(size: 20, weight: .medium))
                .padding(.top)
            MonthlyPlanView(selectedPlan: $selectedPlan).padding(.bottom, 12)
            YearlyPlanView(selectedPlan: $selectedPlan).padding(.bottom)
        }
    }
    
    private func actionButton() -> some View {
        return Button {
            // TODO: action
            viewModel.delegate?.didTapPurchase(plan: self.selectedPlan)
        } label: {
            Text(selectedPlan == .yearly ? "Start Free Trial" : "Continue")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal, 24)
        }
    }
    
    private func restorePurchasesButton() -> some View {
        return Button {
            // TODO: action
            viewModel.delegate?.didTapRestorePurchase()
        } label: {
            Text("Restore Purchases")
                .font(.system(size: 16, weight: .medium))
        }.padding(8)
    }
    
    private func getContentWidth() -> CGFloat {
        let cardWidth: CGFloat = 90
        let spacing: CGFloat = 16
        let padding: CGFloat = 8
        let contentWidth: CGFloat = (cardWidth * 4) + (spacing * 9) + padding
        return contentWidth
    }
    
    private func isIPhone14ProMax() -> Bool {
        return screenSize == iPhone14ProMaxScreenSize
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(viewModel: PaywallViewViewModel(title: "A", subtitle: "B", delegate: nil))
    }
}
