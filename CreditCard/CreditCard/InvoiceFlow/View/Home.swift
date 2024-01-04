//
//  Home.swift
//  CreditCard
//
//  Created by IvanDev on 30.11.23.
//

import SwiftUI
import Charts

struct Home: View {
    var size: CGSize
    @State private var selectedSegment = "Description invoice"
    @State private var shouldShowCreateInvoiceForm = false
    
    var invoices = MockData.shared.invoices
    
    @State var expandInvoices: Bool = false
    
    @State private var showDetailView: Bool = false
    @State private var showDetailContent: Bool = false

    @State private var selectedInvoice: Invoice?
    @Namespace private var animation
    
    // Transactions
    
    var allTransactions = MockData.shared.allTransaction

    @State var expandTransactions: Bool = false
    
    @State private var showDetailTranView: Bool = false
    @State private var showDetailTranContent: Bool = false

    @State private var selectedTransaction: Transaction?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "person.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "questionmark.bubble")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .padding([.horizontal, .top] , 15)
            
            if !expandTransactions {
                InvoiceView()
                    .padding(.horizontal, 10)
                    .frame(maxHeight: .infinity)
            }
            if !expandInvoices {
                TransactionView()
                    .frame(maxHeight: .infinity)
                    .background {
                        CustomCorners(corners: [.topLeft, .topRight], radius: 30)
                            .fill(.gray)
                            .ignoresSafeArea()
                            .shadow(color: .white.opacity(0.05), radius: 10, x: 0, y: -15)
                    }
            }
        }
        .background {
            Rectangle()
                .fill(.red.opacity(0.05))
                .ignoresSafeArea()
        }
        .overlay(content: {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea ()
                .overlay (alignment: .top, content: {
                    HStack {
                        Image (systemName: "chevron.left" )
                            .font (.title3)
                            .fontWeight(.bold)
                            .foregroundColor (.white)
                            .contentShape (Rectangle ())
                            .onTapGesture {
                                withAnimation(.easeInOut (duration: 0.3)) {
                                    expandInvoices = false
                                }
                            }
                        Spacer()
                        Text ("All invoice")
                            .font(.title2.bold())
                    }
                    .padding(15)
                    })
                .opacity(expandInvoices ? 1 : 0)
        })
        .overlay(content: {
            if let selectedInvoice, showDetailView {
                DetailView(selectedInvoice)
                    .transition(.asymmetric(insertion: .identity,
                                            removal: .offset(y: 5)))
            }
        })
        .overlayPreferenceValue(InvoiceRectKey.self) { preferences in
            if let invoicePreference = preferences["InvoiceRect"] {
                GeometryReader { proxy in
                    let cardRect = proxy[invoicePreference]
                    InvoiceContent()
                    // Установка фрейма при распковке списка или других вью
                        .frame(width: cardRect.width,
                               height: expandInvoices ? nil : (cardRect.height))
                        .offset(x: cardRect.minX,
                                y: cardRect.minY)
                }
                .allowsHitTesting(!showDetailView)
            }
        }
        .overlay(content: {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea ()
                .overlay (alignment: .top, content: {
                    HStack {
                        Image (systemName: "chevron.left" )
                            .font (.title3)
                            .fontWeight(.bold)
                            .foregroundColor (.white)
                            .contentShape (Rectangle ())
                            .onTapGesture {
                                withAnimation(.easeInOut (duration: 0.3)) {
                                    expandTransactions = false
                                }
                            }
                        Spacer()
                        Text ("All transactions")
                            .font(.title2.bold())
                    }
                    .padding(15)
                })
                .opacity(expandTransactions ? 1 : 0)
        })
        .overlay(content: {
            if let selectedTransaction, showDetailTranView {
                TransactionDetailView(selectedTransaction)
                    .transition(.asymmetric(insertion: .identity,
                                            removal: .offset(y: 5)))
            }
        })
        .overlayPreferenceValue(InvoiceRectKey.self) { preferences in
            if let transactionPreference = preferences["TransactionRect"] {
                GeometryReader { proxy in
                    let tranRect = proxy[transactionPreference]
                    TransactionContent()
                    // Установка фрейма при распковке списка или других вью
                        .frame(width: tranRect.width,
                               height: expandTransactions ? nil : (tranRect.height))
                        .offset(x: tranRect.minX,
                                y: tranRect.minY)
                }
                .allowsHitTesting(!showDetailTranView)
            }
        }
        .fullScreenCover(isPresented: $shouldShowCreateInvoiceForm) {
            CreateInvoiceView()
        }
    }
    
    @ViewBuilder
    func DetailView(_ invoice: Invoice) -> some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showDetailContent = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut (duration: 0.3)) {
                            showDetailView = false
                        }
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold ())
                }
                
                Spacer()
                
                Text("Detail invoice")
                    .font(.title2.bold())
            }
            .foregroundColor(.white)
            .padding(10)
            .opacity(showDetailContent ? 1 : 0)
            
            InvoiceView(invoice)
                .rotation3DEffect(.init(degrees: showDetailContent ? 0 : -10),
                                  axis: (x: 1, y: 0.7, z: 0), anchor: .top)
                .matchedGeometryEffect(id: invoice.id,
                                       in: animation)
                .frame(height: 200)
                .padding([.horizontal, .top], 15)
                .zIndex(1000)
            
            Picker("Options", selection: $selectedSegment) {
                Text("Description").tag("Description")
                Text("Transaction").tag("Transaction")
            }
            .pickerStyle(.segmented)
            .padding([.top], 30)
            .zIndex(1000)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    if let transactions = invoice.transaction {
                        ForEach(transactions) { tran in
                            HStack {
                                Text(tran.paidAmount)
                                    .font(.title2.bold())
                                Spacer()
                                Text(tran.namePayer)
                                    .font(.title2.italic())
                            }
                            Divider()
                        }
                    }
                }
                .padding (.top, 25)
                .padding ([.horizontal, .bottom], 15)
                .tag("Transaction")
            }
            .background {
                CustomCorners(corners: [.topLeft, .topRight], radius: 30)
                    .fill(.red)
                    .padding (.top, -120)
                    .ignoresSafeArea()
            }
            .offset(y: !showDetailContent ? (size.height * 0.7) : 0)
            .opacity (showDetailContent ? 1: 0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background {
            Rectangle()
                .fill(.orange)
                .ignoresSafeArea()
                .opacity(showDetailContent ? 1 : 0)
        }
    }
    
    
    @ViewBuilder
    func BottomScrollContent() -> some View {

        TabView {
            VStack(alignment: .center, spacing: 8) {
                HStack {
                    Text("Last 6 months")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    Chart(MockData.shared.overviewData) { overview in
                        ForEach(overview.value) { data in
                            BarMark(x: .value("Month", data.month, unit: .month),
                                    y: .value(overview.type.rawValue, data.amount))
                        }
                        .foregroundStyle(by: .value("Type", overview.type.rawValue))
                        .position(by: .value("Type", overview.type.rawValue))
                    }
                    .chartForegroundStyleScale(range: [Color.blue, Color.red])
                    .frame(height: 240)
                    .padding(.top, -20)
                }
            }
            .tabItem {
                Label("Statistic", systemImage: "tray.and.arrow.down.fill")
            }

            TransactionView()
                .tabItem {
                    Label("Transaction", systemImage: "tray.and.arrow.down.fill")
                }

        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(minHeight: 350)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .padding(.vertical, 10)
    }
    
    @ViewBuilder
    func InvoiceView() -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(maxHeight: .infinity)
            .anchorPreference(key: InvoiceRectKey.self,
                              value: .bounds) { anchor in
                return ["InvoiceRect" : anchor]
            }
    }
    
    @ViewBuilder
    func InvoiceView(_ invoice: Invoice) -> some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(invoice.color)
                    .overlay(alignment: .top) {
                        VStack {
                            Text(invoice.number)
                                .font(.title2.italic())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 5)
                            
                            Text(invoice.totalAmount)
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 5)
                        }
                        .padding(20)
                        .foregroundColor(.white)
                    }
                
                Rectangle()
                    .fill(.gray)
                    .frame(height: size.height / 2)
                    .overlay {
                        HStack {
                            Text(invoice.state?.rawValue ?? "")
                                .font(.title2.italic())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 5)
                        }
                        .foregroundColor(.black)
                        .padding(15)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
    
    @ViewBuilder
    func InvoiceContent() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(getListInoicesWithCreateButton()) { invoice in
                    let index = CGFloat(indexOf(invoice))
                    let reversedIndex = CGFloat(invoices.count - 1) - index
                    let displayingStackIndex = min(index, 24)
                    let displayScale = (displayingStackIndex / CGFloat (invoices.count)) * 0.45
                    
                    ZStack {
                        if selectedInvoice?.id == invoice.id && showDetailView {
                            Rectangle()
                                .foregroundColor(.clear)
                        } else {
                            InvoiceView(invoice)
                                .rotation3DEffect(.init(degrees: expandInvoices ? (showDetailView ? 0 : -5) : 0),
                                                  axis: (x: 1, y: 1.2, z: -0.3), anchor: .top)
                                .matchedGeometryEffect(id: invoice.id,
                                                       in: animation)
                                .offset(y: showDetailView ? (size.height * 0.9) : 0)
                                .onTapGesture {
                                    if expandInvoices {
                                        selectedInvoice = invoice
                                        if invoice.number == "Create invoice" {
                                            shouldShowCreateInvoiceForm = true
                                        } else {
                                            withAnimation(.easeInOut (duration: 0.3)) {
                                                showDetailView = true
                                            }
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            withAnimation(.easeInOut (duration: 0.3)) {
                                                showDetailContent = true
                                            }
                                        }
                                    } else {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            expandInvoices = true
                                        }
                                    }
                                }
                        }
                    }
                    .frame(height: getHeight(invoice: invoice))
                    .scaleEffect(1 - (expandInvoices ? 0 : displayScale))
                    .offset (y: expandInvoices ? 0 : (displayingStackIndex * -10))
                    .offset(y: expandInvoices ? -50 : (reversedIndex * -200))
                    .padding(.top, expandInvoices ? 30 : 0)
                }
            }
            .padding(.top, 45)
            .padding(.bottom, CGFloat(invoices.count - 1) * -20)
        }
        .scrollDisabled(!expandInvoices)
    }
    
    // MARK: Transaction
    
    @ViewBuilder
    func TransactionView() -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(maxHeight: .infinity)
            .anchorPreference(key: InvoiceRectKey.self,
                              value: .bounds) { anchor in
                return ["TransactionRect" : anchor]
            }
    }
    
    @ViewBuilder
    func TransactionContent() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(allTransactions) { transaction in
                    let index = CGFloat(indexOfTransaction( transaction))
                    let reversedIndex = CGFloat(allTransactions.count - 1) - index
                    let displayingStackIndex = min(index, 100)
                    let displayScale = (displayingStackIndex / CGFloat (allTransactions.count)) * 0.2
                    
                    ZStack {
                        if selectedTransaction?.id == transaction.id && showDetailTranView {
                            Rectangle()
                                .foregroundColor(.clear)
                        } else {
                            TransactionView(transaction)
                                .rotation3DEffect(.init(degrees: expandTransactions ? (showDetailTranView ? 0 : -5) : 0),
                                                  axis: (x: 1, y: 1.2, z: -0.3), anchor: .top)
                                .matchedGeometryEffect(id: transaction.id,
                                                       in: animation)
                                .offset(y: showDetailTranView ? (size.height * 0.9) : 0)
                                .onTapGesture {
                                    if expandTransactions {
                                        selectedTransaction = transaction
                                        withAnimation(.easeInOut (duration: 0.3)) {
                                            showDetailTranView = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            withAnimation(.easeInOut (duration: 0.3)) {
                                                showDetailTranContent = true
                                            }
                                        }
                                    } else {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            expandTransactions = true
                                        }
                                    }
                                }
                        }
                    }
                    .frame(height: 100)
                    .scaleEffect(1 - (expandTransactions ? 0 : displayScale))
                    .offset (y: expandTransactions ? 0 : (displayingStackIndex * -40))
                    .offset(y: expandTransactions ? -50 : (reversedIndex * -2))
                    .padding(.top, expandTransactions ? 30 : 0)
                }
            }
            .padding(.top, 45)
            .padding(.bottom, CGFloat(allTransactions.count - 1) * -20)
        }
        .scrollDisabled(!expandTransactions)
    }
    
    @ViewBuilder
    func TransactionView(_ transaction: Transaction) -> some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(transaction.color)
                    .overlay(alignment: .top) {
                        HStack {
                            Text(transaction.namePayer)
                                .font(.title2.italic())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 5)
                            
                            Text(transaction.paidAmount)
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 5)
                            
                            Text("Date")
                                .font(.title2.smallCaps())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 5)
                            
                            Text("Number invoice")
                                .font(.title2.smallCaps())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 5)
                        }
                        .padding(20)
                        .foregroundColor(.white)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
    
    @ViewBuilder
    func TransactionDetailView(_ transaction: Transaction) -> some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showDetailTranContent = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut (duration: 0.3)) {
                            showDetailTranView = false
                        }
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold ())
                }
                
                Spacer()
                
                Text("Detail invoice")
                    .font(.title2.bold())
            }
            .foregroundColor(.white)
            .padding(10)
            .opacity(showDetailTranContent ? 1 : 0)
            
            TransactionView(transaction)
                .rotation3DEffect(.init(degrees: showDetailTranContent ? 0 : -10),
                                  axis: (x: 1, y: 0.7, z: 0), anchor: .top)
                .matchedGeometryEffect(id: transaction.id,
                                       in: animation)
                .frame(height: 200)
                .padding([.horizontal, .top], 15)
                .zIndex(1000)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    VStack(spacing: 40) {
                        Text("other description transaction")
                            .font(.title2.bold())
                        Text("other description transaction")
                            .font(.title2.bold())
                        Text("other description transaction")
                            .font(.title2.bold())
                        Text("other description transaction")
                            .font(.title2.bold())
                        Text("other description transaction")
                            .font(.title2.bold())
                        Text("other description transaction")
                            .font(.title2.bold())
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding (.top, 25)
                .padding ([.horizontal, .bottom], 15)
            }
            .background {
                CustomCorners(corners: [.topLeft, .topRight], radius: 30)
                    .fill(.red)
                    .padding (.top, -120)
                    .ignoresSafeArea()
            }
            .offset(y: !showDetailTranContent ? (size.height * 0.7) : 0)
            .opacity (showDetailTranContent ? 1: 0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background {
            Rectangle()
                .fill(.orange)
                .ignoresSafeArea()
                .opacity(showDetailTranContent ? 1 : 0)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceMainView()
    }
}

extension Home {
    func indexOf(_ invoice: Invoice) -> Int {
        return invoices.firstIndex {
            invoice.id == $0.id
        } ?? 0
    }
    
    func indexOfTransaction(_ transaction: Transaction) -> Int {
        return allTransactions.firstIndex {
            transaction.id == $0.id
        } ?? 0
    }
    
    func getListInoicesWithCreateButton() -> [Invoice] {
        var createButtonCell = Invoice(number: "Create invoice", totalAmount: "")
        createButtonCell.color = .gray
        var newInvoices = invoices
        newInvoices.append(createButtonCell)
        return expandInvoices ? newInvoices.reversed() : invoices.reversed()
    }
    
    func getHeight(invoice: Invoice) -> CGFloat {
        var height = CGFloat(230)
        if invoice.number == "Create invoice" {
            height = 100
        }
        return height
    }
}
