//
//  ErrorScreenView.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import SwiftUI

struct ErrorScreenView: View {
    private enum Constant {
        static let verticalSpacing: CGFloat = 20
        enum WarningIcon {
            static let name = "exclamationmark.triangle.fill"
            static let size: CGFloat = 60
            static let color: Color = .red
        }
        enum RetryButton {
            static let cornerRadius: CGFloat = 10
            static let padding: CGFloat = 20
            static let foregroundColor: Color = .white
            static let backgroundColor: Color = .blue
        }
        enum ErrorMessage {
            static let foregroundColor: Color = .gray
        }
    }
    
    var errorMessage: String
    var onRetry: () -> Void

    var body: some View {
        VStack(spacing: Constant.verticalSpacing) {
            Spacer()
            buildContent()
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func buildContent() -> some View {
        buildWarningIcon()
        buildErrorMessage()
        buildRetryButton()
    }
    
    private func buildWarningIcon() -> some View {
        Image(systemName: Constant.WarningIcon.name)
            .font(.system(size: Constant.WarningIcon.size))
            .foregroundColor(Constant.WarningIcon.color)
    }
    
    private func buildRetryButton() -> some View {
        Button(action: onRetry) {
            Text("key_retry")
                .font(.title3)
                .foregroundColor(Constant.RetryButton.foregroundColor)
                .padding()
                .background(Constant.RetryButton.backgroundColor)
                .cornerRadius(Constant.RetryButton.cornerRadius)
        }
        .padding(.top, Constant.RetryButton.padding)
    }
    
    private func buildErrorMessage() -> some View {
        Text(errorMessage)
            .font(.headline)
            .foregroundColor(Constant.ErrorMessage.foregroundColor)
            .multilineTextAlignment(.center)
            .padding()
    }
}

#Preview {
    ErrorScreenView(errorMessage: "Error de descarga") {
        debugPrint("Retrying...")
    }
}
