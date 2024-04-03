import SwiftUI

struct MatchesView: View {
    
    @StateObject var viewModel: MatchesViewModel = MatchesViewModel()

    
    var body: some View {
        VStack {
            Text("Matches")
                .font(.title)
                .padding() // Assuming this is some kind of profile header
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.matches.indices, id: \.self) { index in
                        if let match = viewModel.matches[index] as? [String: Any],
                           let name = match["name"] as? String,
                           let email = match["email"] as? String
                        {
                            let instagram = match["instagram"] as? String
                            let linkedin = match["linkedin"] as? String
                            MatchCard(name: name, email: email, instagram: instagram, linkedin: linkedin)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct MatchCard: View {
    let name: String
    let email: String
    let instagram: String?
    let linkedin: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(name)
                .font(.headline)
                .padding(.bottom, 5)
             Text(email)
                 .font(.subheadline)
                 .foregroundColor(.gray)
                 .padding(.bottom, 5)
            if let instagram = instagram {
                Text(instagram)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 5)
            }
            if let linkedin = linkedin {
                Text(linkedin)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
    }
}
