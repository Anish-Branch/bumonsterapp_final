//
//  OnBoardingPage.swift
//  bumonsterapp
//
//  Created by Anish Somani on 06/10/2023.
//

import SwiftUI
import BranchSDK

// To Use the custom font on all pages..
let customFont = "Raleway-Regular"

enum SelectionType: Int, Identifiable {
    var id: Int { rawValue }
    case login
    case register
    case guest
}

class OnboardingViewModel: ObservableObject {
    @Published var selectionType: SelectionType?
}

struct OnBoardingPage: View {
    @StateObject var viewModel = OnboardingViewModel()
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 100)
            AppLogo()
            Spacer()
                .frame(height: 100)

            VStack {
                Text("Existing User?")
                ThemeButton(title: "Login") {
                    viewModel.selectionType = .login
                }
                .padding(.horizontal, 20)
            }
            Spacer()
                .frame(height: 50)
            VStack {
                Text("New User?")
                ThemeButton(title: "Create account") {
                    viewModel.selectionType = .register
                }
                .padding(.horizontal, 20)
            }

            Spacer()
            Button("Continue as guest") {
                //Show the main pge here.
                //viewModel.selectionType = .guest
                LoginPageModel().loginAsGuest()
                branchEventGuestLogin()
                print("Guest Login Complete")
            }
            .fontWeight(.bold)
            .foregroundColor(Constants.Colors.themeBlue)
        }
        .background(Constants.Colors.appBackground)
        .fullScreenCover(item: $viewModel.selectionType) { selectionType in
            switch selectionType {
//            case .guest:
//                //Not used anymore and can be safely removed
//                MainPage()
            default:
                LoginPage(loginData: LoginPageModel(registerUser: selectionType == .register ? true : false))
            }
        }
    }
}


// Branch.io - Track Event - Guest Login
func branchEventGuestLogin(){
    // Create a BranchEvent:
    let event = BranchEvent.customEvent(withName: "Guest_Login")

    // Add relevant event data:
    event.alias            = "Continue as Guest"
    event.eventDescription = "Guest Login"
    event.logEvent() // Log the event.
}

struct OnBoardingPage_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingPage()
    }
}

// Extending View to get Screen Bounds..
extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
