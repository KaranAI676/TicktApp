//
//  PaymentIntentParams.swift
//  StripeiOS
//
//  Created by David Estes on 6/29/21.
//  Copyright © 2021 Stripe, Inc. All rights reserved.
//

import Foundation
@_spi(STP) import StripeCore

extension StripeAPI {
    @_spi(STP) public struct PaymentIntentParams: StripeEncodable {
        /// The client secret of the PaymentIntent. Required
        @_spi(STP) public let clientSecret: String
        
        @_spi(STP) public init(clientSecret: String) {
            self.clientSecret = clientSecret
        }
        
        @_spi(STP) public var id: String? {
            return PaymentIntent.id(fromClientSecret: clientSecret)
        }

        /// Provide a supported `PaymentMethodParams` object, and Stripe will create a
        /// PaymentMethod during PaymentIntent confirmation.
        /// @note alternative to `paymentMethodId`
        @IncludeUnknownFields
        @_spi(STP) public var paymentMethodData: PaymentMethodParams?

        /// Provide an already created PaymentMethod's id, and it will be used to confirm the PaymentIntent.
        /// @note alternative to `paymentMethodParams`
        @_spi(STP) public var paymentMethod: String?

        /// Provide an already created Source's id, and it will be used to confirm the PaymentIntent.
        @_spi(STP) public var sourceId: String?

        /// Email address that the receipt for the resulting payment will be sent to.
        @_spi(STP) public var receiptEmail: String?

        /// `@YES` to save this PaymentIntent’s PaymentMethod or Source to the associated Customer,
        /// if the PaymentMethod/Source is not already attached.
        /// This should be a boolean NSNumber, so that it can be `nil`
        @_spi(STP) public var savePaymentMethod: Bool?

        /// The URL to redirect your customer back to after they authenticate or cancel
        /// their payment on the payment method’s app or site.
        /// This should probably be a URL that opens your iOS app.
        @_spi(STP) public var returnURL: String?

        /// When provided, this property indicates how you intend to use the payment method that your customer provides after the current payment completes.
        /// If applicable, additional authentication may be performed to comply with regional legislation or network rules required to enable the usage of the same payment method for additional payments.
        @_spi(STP) public var setupFutureUsage: SetupFutureUsage?
        
        /// A boolean number to indicate whether you intend to use the Stripe SDK's functionality to handle any PaymentIntent next actions.
        /// If set to false, STPPaymentIntent.nextAction will only ever contain a redirect url that can be opened in a webview or mobile browser.
        /// When set to true, the nextAction may contain information that the Stripe SDK can use to perform native authentication within your
        /// app.
        @_spi(STP) public var useStripeSdk: Bool?
        
        /// Shipping information.
        @IncludeUnknownFields
        @_spi(STP) public var shipping: ShippingDetails?
        
        
        @_spi(STP) public struct ShippingDetails: StripeEncodable {
            /// Generated by by Editor -> Refactor -> Generate Memberwise Initializer
            @_spi(STP) public init(address: StripeAPI.PaymentIntentParams.ShippingDetails.Address, name: String, carrier: String? = nil, phone: String? = nil, trackingNumber: String? = nil, _additionalParametersStorage: NonEncodableParameters? = nil) {
                self.address = address
                self.name = name
                self.carrier = carrier
                self.phone = phone
                self.trackingNumber = trackingNumber
                self._additionalParametersStorage = _additionalParametersStorage
            }
            
            /// Shipping address.
            @_spi(STP) public var address: Address

            /// Recipient name.
            @_spi(STP) public var name: String

            /// The delivery service that shipped a physical product, such as Fedex, UPS, USPS, etc.
            @_spi(STP) public var carrier: String?

            /// Recipient phone (including extension).
            @_spi(STP) public var phone: String?

            /// The tracking number for a physical product, obtained from the delivery service. If multiple tracking numbers were generated for this purchase, please separate them with commas.
            @_spi(STP) public var trackingNumber: String?
            
            @_spi(STP) public var _additionalParametersStorage: NonEncodableParameters?
            
            @_spi(STP) public struct Address: StripeEncodable {
                /// Generated by by Editor -> Refactor -> Generate Memberwise Initializer
                @_spi(STP) public init(city: String? = nil, country: String? = nil, line1: String, line2: String? = nil, postalCode: String? = nil, state: String? = nil, _additionalParametersStorage: NonEncodableParameters? = nil) {
                    self.city = city
                    self.country = country
                    self.line1 = line1
                    self.line2 = line2
                    self.postalCode = postalCode
                    self.state = state
                    self._additionalParametersStorage = _additionalParametersStorage
                }
                
                /// City/District/Suburb/Town/Village.
                @_spi(STP) public var city: String?

                /// Two-letter country code (ISO 3166-1 alpha-2).
                @_spi(STP) public var country: String?

                /// Address line 1 (Street address/PO Box/Company name).
                @_spi(STP) public var line1: String

                /// Address line 2 (Apartment/Suite/Unit/Building).
                @_spi(STP) public var line2: String?

                /// ZIP or postal code.
                @_spi(STP) public var postalCode: String?

                /// State/County/Province/Region.
                @_spi(STP) public var state: String?
                
                @_spi(STP) public var _additionalParametersStorage: NonEncodableParameters?
            }
        }

        /// Indicates how you intend to use the payment method that your customer provides after the current payment completes.
        /// If applicable, additional authentication may be performed to comply with regional legislation or network rules required to enable the usage of the same payment method for additional payments.
        /// - seealso: https://stripe.com/docs/api/payment_intents/object#payment_intent_object-setup_future_usage
        @frozen @_spi(STP) public enum SetupFutureUsage: String, StripeEnumCodable {
            /// Unknown value.  Update your SDK, or use `allResponseFields` for custom handling.
            case unknown
            /// No value was provided.
            case none
            /// Indicates you intend to only reuse the payment method when the customer is in your checkout flow.
            case onSession
            /// Indicates you intend to reuse the payment method when the customer may or may not be in your checkout flow.
            case offSession
            
            case unparsable
            // TODO: This is @frozen because of a bug in the Xcode 12.2 Swift compiler.
            // Remove @frozen after Xcode 12.2 support has been dropped.
        }

        @_spi(STP) public var _additionalParametersStorage: NonEncodableParameters?
    }
}

extension StripeAPI.PaymentIntentParams {
    static internal let isClientSecretValidRegex: NSRegularExpression = try! NSRegularExpression(
        pattern: "^pi_[^_]+_secret_[^_]+$", options: [])

    static internal func isClientSecretValid(_ clientSecret: String) -> Bool {
        return
            (isClientSecretValidRegex.numberOfMatches(
                in: clientSecret,
                options: .anchored,
                range: NSRange(location: 0, length: clientSecret.count))) == 1
    }
}
