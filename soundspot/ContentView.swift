import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Boarding()
            
        }.padding(10)
    }
}

struct CardView: View{
    var title : String
    var secureField : Bool
    @State private var input : String = ""
    var body: some View{
        VStack(alignment: .leading){
            Text(title).font(.subheadline).foregroundColor(Color("black"))
            ZStack{
                let shape = RoundedRectangle(cornerRadius : 10)
                shape.fill().foregroundColor(Color("lightGray"))
                if(secureField){
                    SecureField("", text: $input)
                        .padding(.horizontal, 10)
                }
                else{
                    TextField("", text: $input)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        
                }
                
            }.frame(height: 35.0)
        }
        
    }
}

struct CTAButton: View{
    var title : String
    var body: some View{
        ZStack{
            Button(title,action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/)
                .frame(maxWidth: .infinity, maxHeight:35.0)
                .foregroundColor(.white)
                .background(Color("lightBlue"))
                .padding(.horizontal, 100)
                .cornerRadius(10)
        }
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
