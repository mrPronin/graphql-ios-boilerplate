//  This file was automatically generated and should not be edited.

import Apollo

public struct CreateUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: Swift.Optional<String?> = nil, email: String, password: String, lastName: Swift.Optional<String?> = nil, picture: Swift.Optional<String?> = nil) {
    graphQLMap = ["name": name, "email": email, "password": password, "lastName": lastName, "picture": picture]
  }

  public var name: Swift.Optional<String?> {
    get {
      return graphQLMap["name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var email: String {
    get {
      return graphQLMap["email"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var password: String {
    get {
      return graphQLMap["password"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
    }
  }

  public var lastName: Swift.Optional<String?> {
    get {
      return graphQLMap["lastName"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var picture: Swift.Optional<String?> {
    get {
      return graphQLMap["picture"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "picture")
    }
  }
}

public struct LoginUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(email: String, password: String) {
    graphQLMap = ["email": email, "password": password]
  }

  public var email: String {
    get {
      return graphQLMap["email"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var password: String {
    get {
      return graphQLMap["password"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
    }
  }
}

public struct AuthInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(accessToken: String, refreshToken: String) {
    graphQLMap = ["accessToken": accessToken, "refreshToken": refreshToken]
  }

  public var accessToken: String {
    get {
      return graphQLMap["accessToken"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "accessToken")
    }
  }

  public var refreshToken: String {
    get {
      return graphQLMap["refreshToken"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "refreshToken")
    }
  }
}

public enum AuthProviderType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case google
  case facebook
  case email
  case undefined
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "GOOGLE": self = .google
      case "FACEBOOK": self = .facebook
      case "EMAIL": self = .email
      case "UNDEFINED": self = .undefined
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .google: return "GOOGLE"
      case .facebook: return "FACEBOOK"
      case .email: return "EMAIL"
      case .undefined: return "UNDEFINED"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: AuthProviderType, rhs: AuthProviderType) -> Bool {
    switch (lhs, rhs) {
      case (.google, .google): return true
      case (.facebook, .facebook): return true
      case (.email, .email): return true
      case (.undefined, .undefined): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [AuthProviderType] {
    return [
      .google,
      .facebook,
      .email,
      .undefined,
    ]
  }
}

public final class CreateUserMutation: GraphQLMutation {
  /// mutation CreateUser($data: CreateUserInput!) {
  ///   createUser(data: $data) {
  ///     __typename
  ///     token
  ///     user {
  ///       __typename
  ///       ...UserDetails
  ///     }
  ///   }
  /// }
  public let operationDefinition =
    "mutation CreateUser($data: CreateUserInput!) { createUser(data: $data) { __typename token user { __typename ...UserDetails } } }"

  public let operationName = "CreateUser"

  public var queryDocument: String { return operationDefinition.appending(UserDetails.fragmentDefinition) }

  public var data: CreateUserInput

  public init(data: CreateUserInput) {
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createUser", arguments: ["data": GraphQLVariable("data")], type: .nonNull(.object(CreateUser.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createUser: CreateUser) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createUser": createUser.resultMap])
    }

    public var createUser: CreateUser {
      get {
        return CreateUser(unsafeResultMap: resultMap["createUser"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "createUser")
      }
    }

    public struct CreateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["AuthPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("token", type: .nonNull(.scalar(String.self))),
        GraphQLField("user", type: .nonNull(.object(User.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String, user: User) {
        self.init(unsafeResultMap: ["__typename": "AuthPayload", "token": token, "user": user.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }

      public var user: User {
        get {
          return User(unsafeResultMap: resultMap["user"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "user")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(UserDetails.self),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String? = nil, lastName: String? = nil, email: String? = nil, picture: String? = nil, signupType: AuthProviderType, createdAt: String, updatedAt: String) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "name": name, "lastName": lastName, "email": email, "picture": picture, "signupType": signupType, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var userDetails: UserDetails {
            get {
              return UserDetails(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class LoginMutation: GraphQLMutation {
  /// mutation Login($data: LoginUserInput!) {
  ///   login(data: $data) {
  ///     __typename
  ///     token
  ///     user {
  ///       __typename
  ///       ...UserDetails
  ///     }
  ///   }
  /// }
  public let operationDefinition =
    "mutation Login($data: LoginUserInput!) { login(data: $data) { __typename token user { __typename ...UserDetails } } }"

  public let operationName = "Login"

  public var queryDocument: String { return operationDefinition.appending(UserDetails.fragmentDefinition) }

  public var data: LoginUserInput

  public init(data: LoginUserInput) {
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("login", arguments: ["data": GraphQLVariable("data")], type: .nonNull(.object(Login.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(login: Login) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "login": login.resultMap])
    }

    public var login: Login {
      get {
        return Login(unsafeResultMap: resultMap["login"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "login")
      }
    }

    public struct Login: GraphQLSelectionSet {
      public static let possibleTypes = ["AuthPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("token", type: .nonNull(.scalar(String.self))),
        GraphQLField("user", type: .nonNull(.object(User.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String, user: User) {
        self.init(unsafeResultMap: ["__typename": "AuthPayload", "token": token, "user": user.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }

      public var user: User {
        get {
          return User(unsafeResultMap: resultMap["user"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "user")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(UserDetails.self),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String? = nil, lastName: String? = nil, email: String? = nil, picture: String? = nil, signupType: AuthProviderType, createdAt: String, updatedAt: String) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "name": name, "lastName": lastName, "email": email, "picture": picture, "signupType": signupType, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var userDetails: UserDetails {
            get {
              return UserDetails(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class MeQuery: GraphQLQuery {
  /// query Me {
  ///   me {
  ///     __typename
  ///     ...UserDetails
  ///   }
  /// }
  public let operationDefinition =
    "query Me { me { __typename ...UserDetails } }"

  public let operationName = "Me"

  public var queryDocument: String { return operationDefinition.appending(UserDetails.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("me", type: .nonNull(.object(Me.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(me: Me) {
      self.init(unsafeResultMap: ["__typename": "Query", "me": me.resultMap])
    }

    public var me: Me {
      get {
        return Me(unsafeResultMap: resultMap["me"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "me")
      }
    }

    public struct Me: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(UserDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil, lastName: String? = nil, email: String? = nil, picture: String? = nil, signupType: AuthProviderType, createdAt: String, updatedAt: String) {
        self.init(unsafeResultMap: ["__typename": "User", "id": id, "name": name, "lastName": lastName, "email": email, "picture": picture, "signupType": signupType, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userDetails: UserDetails {
          get {
            return UserDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class DeleteUserMutation: GraphQLMutation {
  /// mutation DeleteUser {
  ///   deleteUser {
  ///     __typename
  ///     ...UserDetails
  ///   }
  /// }
  public let operationDefinition =
    "mutation DeleteUser { deleteUser { __typename ...UserDetails } }"

  public let operationName = "DeleteUser"

  public var queryDocument: String { return operationDefinition.appending(UserDetails.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteUser", type: .nonNull(.object(DeleteUser.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteUser: DeleteUser) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteUser": deleteUser.resultMap])
    }

    public var deleteUser: DeleteUser {
      get {
        return DeleteUser(unsafeResultMap: resultMap["deleteUser"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "deleteUser")
      }
    }

    public struct DeleteUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(UserDetails.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil, lastName: String? = nil, email: String? = nil, picture: String? = nil, signupType: AuthProviderType, createdAt: String, updatedAt: String) {
        self.init(unsafeResultMap: ["__typename": "User", "id": id, "name": name, "lastName": lastName, "email": email, "picture": picture, "signupType": signupType, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userDetails: UserDetails {
          get {
            return UserDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class ContinueWithGoogleMutation: GraphQLMutation {
  /// mutation ContinueWithGoogle($data: AuthInput!) {
  ///   continueWithGoogle(data: $data) {
  ///     __typename
  ///     token
  ///   }
  /// }
  public let operationDefinition =
    "mutation ContinueWithGoogle($data: AuthInput!) { continueWithGoogle(data: $data) { __typename token } }"

  public let operationName = "ContinueWithGoogle"

  public var data: AuthInput

  public init(data: AuthInput) {
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("continueWithGoogle", arguments: ["data": GraphQLVariable("data")], type: .nonNull(.object(ContinueWithGoogle.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(continueWithGoogle: ContinueWithGoogle) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "continueWithGoogle": continueWithGoogle.resultMap])
    }

    public var continueWithGoogle: ContinueWithGoogle {
      get {
        return ContinueWithGoogle(unsafeResultMap: resultMap["continueWithGoogle"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "continueWithGoogle")
      }
    }

    public struct ContinueWithGoogle: GraphQLSelectionSet {
      public static let possibleTypes = ["AuthPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("token", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String) {
        self.init(unsafeResultMap: ["__typename": "AuthPayload", "token": token])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }
    }
  }
}

public final class ContinueWithFacebookMutation: GraphQLMutation {
  /// mutation ContinueWithFacebook($data: AuthInput!) {
  ///   continueWithFacebook(data: $data) {
  ///     __typename
  ///     token
  ///   }
  /// }
  public let operationDefinition =
    "mutation ContinueWithFacebook($data: AuthInput!) { continueWithFacebook(data: $data) { __typename token } }"

  public let operationName = "ContinueWithFacebook"

  public var data: AuthInput

  public init(data: AuthInput) {
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("continueWithFacebook", arguments: ["data": GraphQLVariable("data")], type: .nonNull(.object(ContinueWithFacebook.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(continueWithFacebook: ContinueWithFacebook) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "continueWithFacebook": continueWithFacebook.resultMap])
    }

    public var continueWithFacebook: ContinueWithFacebook {
      get {
        return ContinueWithFacebook(unsafeResultMap: resultMap["continueWithFacebook"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "continueWithFacebook")
      }
    }

    public struct ContinueWithFacebook: GraphQLSelectionSet {
      public static let possibleTypes = ["AuthPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("token", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String) {
        self.init(unsafeResultMap: ["__typename": "AuthPayload", "token": token])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }
    }
  }
}

public struct UserDetails: GraphQLFragment {
  /// fragment UserDetails on User {
  ///   __typename
  ///   id
  ///   name
  ///   lastName
  ///   email
  ///   picture
  ///   signupType
  ///   createdAt
  ///   updatedAt
  /// }
  public static let fragmentDefinition =
    "fragment UserDetails on User { __typename id name lastName email picture signupType createdAt updatedAt }"

  public static let possibleTypes = ["User"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("name", type: .scalar(String.self)),
    GraphQLField("lastName", type: .scalar(String.self)),
    GraphQLField("email", type: .scalar(String.self)),
    GraphQLField("picture", type: .scalar(String.self)),
    GraphQLField("signupType", type: .nonNull(.scalar(AuthProviderType.self))),
    GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
    GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String? = nil, lastName: String? = nil, email: String? = nil, picture: String? = nil, signupType: AuthProviderType, createdAt: String, updatedAt: String) {
    self.init(unsafeResultMap: ["__typename": "User", "id": id, "name": name, "lastName": lastName, "email": email, "picture": picture, "signupType": signupType, "createdAt": createdAt, "updatedAt": updatedAt])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var lastName: String? {
    get {
      return resultMap["lastName"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var email: String? {
    get {
      return resultMap["email"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "email")
    }
  }

  public var picture: String? {
    get {
      return resultMap["picture"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "picture")
    }
  }

  public var signupType: AuthProviderType {
    get {
      return resultMap["signupType"]! as! AuthProviderType
    }
    set {
      resultMap.updateValue(newValue, forKey: "signupType")
    }
  }

  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: String {
    get {
      return resultMap["updatedAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "updatedAt")
    }
  }
}
