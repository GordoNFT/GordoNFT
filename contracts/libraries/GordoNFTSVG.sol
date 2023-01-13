// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.6;
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";

/// @title GordoNFTSVG
/// @notice Provides a function for generating an SVG associated with a Uniswap NFT
library GordoNFTSVG {
    using Strings for uint256;
    struct SVGParams {
        uint256 ticket;
        bool active;
        bool isWinner;
    }

    function generateSVG(SVGParams memory params)
        internal
        pure
        returns (string memory svg)
    {
        return
            string(
                abi.encodePacked(
                    generateSVGDefs(params),
                    generateSVGLinearGradient(params),
                    generateSVGCurveAndText(params.ticket)
                )
            );
    }

    function generateSVGDefs(SVGParams memory params)
        private
        pure
        returns (string memory svg)
    {
        string memory color0 = params.active ? "#754c24" : "#545454";
        string memory color1 = params.active ? "#8c6239" : "#6a6a6a";
        if (params.isWinner) {
            svg = string(
                abi.encodePacked(
                    '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 1122.22 548.88">',
                    "<defs><style> .a {fill: #999;}.b {}.c {fill: none;stroke-width: 6px;}.c,.i {stroke: #754c24;stroke-miterlimit: 10;}",
                    ".d {font-size: 201.01px;fill: #ffe68a;transform-origin: 120px 0;}.d,.i {font-family: Algerian;}.f {fill: url(#b);}",
                    ".g {fill: url(#c);}.h {fill: url(#d);}.i {font-size: 96.75px;fill: #ffe29f;}</style>"
                )
            );
        } else {
            svg = string(
                abi.encodePacked(
                    '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 1122.22 548.88">',
                    "<defs><style>.a{fill: #999;}.b{fill:url(#a);}.c{fill:none;stroke-width:6px;}.c,.i{stroke:",
                    color0,
                    ";stroke-miterlimit:10;}.d{font-size:201.01px;fill:",
                    color1,
                    ";font-family:TimesNewRomanPS-BoldMT,Times New Roman;font-weight:700;}.e{letter-spacing:-0.02em;}.f{fill:url(#b);}.g{fill:url(#c);}.h{fill:url(#d);}.i{font-size:96.75px;fill:",
                    color0,
                    ";font-family:CourierNewPSMT,Courier New;}</style>"
                )
            );
        }
    }

    function generateSVGLinearGradient(SVGParams memory params)
        private
        pure
        returns (string memory svg)
    {
        svg = params.isWinner
            ? string(
                abi.encodePacked(
                    '<linearGradient id="b" x1="486.95" y1="263.68" x2="419.09" y2="302.86" gradientUnits="userSpaceOnUse">',
                    '<stop offset="0.21" stop-color="#fbdb70" /><stop offset="0.27" stop-color="#e5c261" />',
                    '<stop offset="0.36" stop-color="#cea951" /><stop offset="0.42" stop-color="#c7a24e" />',
                    '<stop offset="0.51" stop-color="#e3c677" /><stop offset="0.6" stop-color="#f5dc91" />',
                    '<stop offset="0.65" stop-color="#fbe49a" /><stop offset="0.72" stop-color="#f8e197" />',
                    '<stop offset="0.78" stop-color="#f1d88c" /><stop offset="0.84" stop-color="#e3c97b" />',
                    '<stop offset="0.89" stop-color="#d0b362" /><stop offset="0.94" stop-color="#b89743" />',
                    '<stop offset="0.99" stop-color="#9b761c" /><stop offset="1" stop-color="#855d00" /></linearGradient>',
                    '<linearGradient id="c" x1="599.42" y1="263.68" x2="531.56" y2="302.86" xlink:href="#b" />',
                    '<linearGradient id="d" x1="704.02" y1="263.68" x2="636.16" y2="302.86" xlink:href="#b" /></defs>'
                )
            )
            : params.active
            ? string(
                abi.encodePacked(
                    '<linearGradient id="a" x1="62.14" y1="459.18" x2="1176.36" y2="459.18" gradientUnits="userSpaceOnUse">',
                    '<stop offset="0" stop-color="#7a5414" /><stop offset="0.08" stop-color="#b39249" />',
                    '<stop offset="0.15" stop-color="#dabc6d" /><stop offset="0.2" stop-color="#f2d684" />',
                    '<stop offset="0.23" stop-color="#fbe08c" /><stop offset="0.35" stop-color="#e2c270" />',
                    '<stop offset="0.49" stop-color="#cda958" /><stop offset="0.57" stop-color="#c5a04f" />',
                    '<stop offset="0.65" stop-color="#d2ae56" /><stop offset="0.79" stop-color="#f3d26a" />',
                    '<stop offset="0.82" stop-color="#fad96e" /><stop offset="0.86" stop-color="#f5d46a" />',
                    '<stop offset="0.91" stop-color="#e8c45f" /><stop offset="0.96" stop-color="#d1ab4c" />',
                    '<stop offset="0.99" stop-color="#c0973e" /></linearGradient>',
                    '<linearGradient id="b" x1="486.95" y1="263.68" x2="419.09" y2="302.86" gradientUnits="userSpaceOnUse">',
                    '<stop offset="0.21" stop-color="#fbdb70" /><stop offset="0.27" stop-color="#e5c261" />',
                    '<stop offset="0.36" stop-color="#cea951" /><stop offset="0.42" stop-color="#c7a24e" />',
                    '<stop offset="0.51" stop-color="#e3c677" /><stop offset="0.6" stop-color="#f5dc91" />',
                    '<stop offset="0.65" stop-color="#fbe49a" /><stop offset="0.72" stop-color="#f8e197" />',
                    '<stop offset="0.78" stop-color="#f1d88c" /><stop offset="0.84" stop-color="#e3c97b" />',
                    '<stop offset="0.89" stop-color="#d0b362" /><stop offset="0.94" stop-color="#b89743" />',
                    '<stop offset="0.99" stop-color="#9b761c" /><stop offset="1" stop-color="#855d00" /></linearGradient>',
                    '<linearGradient id="c" x1="599.42" y1="263.68" x2="531.56" y2="302.86" xlink:href="#b" />',
                    '<linearGradient id="d" x1="704.02" y1="263.68" x2="636.16" y2="302.86" xlink:href="#b" /></defs>'
                )
            )
            : string(
                abi.encodePacked(
                    '<linearGradient id="a" x1="62.14" y1="459.18" x2="1176.36" y2="459.18" gradientUnits="userSpaceOnUse">',
                    '<stop offset="0" stop-color="#585858" /><stop offset="0.08" stop-color="#919191" />',
                    '<stop offset="0.15" stop-color="#bbb" /><stop offset="0.2" stop-color="#d5d5d5" />',
                    '<stop offset="0.23" stop-color="#dfdfdf" /><stop offset="0.35" stop-color="#c4c4c4" />',
                    '<stop offset="0.49" stop-color="#ababab" /><stop offset="0.57" stop-color="#a2a2a2" />',
                    '<stop offset="0.65" stop-color="#b0b0b0" /><stop offset="0.79" stop-color="#d4d4d4" />',
                    '<stop offset="0.82" stop-color="#d7d7d7" /><stop offset="0.86" stop-color="#d2d2d2" />',
                    '<stop offset="0.91" stop-color="#c2c2c2" /><stop offset="0.96" stop-color="#a9a9a9" />',
                    '<stop offset="0.99" stop-color="#9a9a9a" /></linearGradient>',
                    '<linearGradient id="b" x1="486.95" y1="263.68" x2="419.09" y2="302.86" gradientUnits="userSpaceOnUse">',
                    '<stop offset="0.21" stop-color="#d9d9d9" /><stop offset="0.27" stop-color="#c4c4c4" />',
                    '<stop offset="0.36" stop-color="#ababab" /><stop offset="0.42" stop-color="#a1a1a1" />',
                    '<stop offset="0.51" stop-color="#c0c0c0" /><stop offset="0.6" stop-color="#dadada" />',
                    '<stop offset="0.65" stop-color="#e3e3e3" /><stop offset="0.72" stop-color="#e0e0e0" />',
                    '<stop offset="0.78" stop-color="#d5d5d5" /><stop offset="0.84" stop-color="#c4c4c4" />',
                    '<stop offset="0.89" stop-color="#ababab" /><stop offset="0.94" stop-color="#8c8c8c" />',
                    '<stop offset="0.99" stop-color="#656565" /><stop offset="1" stop-color="#5f5f5f" /></linearGradient>',
                    '<linearGradient id="c" x1="599.42" y1="263.68" x2="531.56" y2="302.86" xlink:href="#b" />',
                    '<linearGradient id="d" x1="704.02" y1="263.68" x2="636.16" y2="302.86" xlink:href="#b" /></defs>'
                )
            );
    }

    function generateSVGCurveAndText(uint256 ticket)
        private
        pure
        returns (string memory svg)
    {
        string memory str_ticket = uintToString(ticket);
        svg = string(
            abi.encodePacked(
                '<path class="a" d="M1178.39,739.12H86S64.78,662.51,82.21,579.4C99.87,495.17,87.64,434,74.13,356.21c-12.64-72.82,8.81-155,8.81-155H1161.73s-22.62,75.21,4.55,137.7-21.73,168.46,4.08,245.89S1178.39,739.12,1178.39,739.12Z"',
                ' transform="translate(-62.14 -190.24)" /><path class="b" d="M1170.39,728.12H78S56.78,651.51,74.21,568.4C91.87,484.17,79.64,423,66.13,345.21c-12.64-72.82,8.81-155,8.81-155H1153.73s-22.62,75.21,4.55,137.7-21.73,168.46,4.08,245.89S1170.39,728.12,1170.39,728.12Z"',
                ' transform="translate(-62.14 -190.24)" /><rect class="c" x="70.37" y="52.03" width="980.3" height="442.42" />',
                '<path class="c" d="M270.39,243.79V683.18" transform="translate(-62.14 -190.24)" /><path class="c" d="M976.45,243.79V683.18" transform="translate(-62.14 -190.24)" /><text class="d"',
                ' transform="translate(306.74 227.32) scale(0.68 1)">GORDO<tspan x="-9.47" y="241.21">TICKET</tspan></text>',
                '<polygon class="f" points="418.16 264.35 440.58 264.35 452.8 244.54 463.33 264.35 487.33 264.35 472.16 283.82 487.33 302.5 462.65 302.05 451.9 320.61 440.92 301.71 418.16 301.25 431.18 281.78 418.16 264.35" />',
                '<polygon class="g" points="530.63 264.35 553.05 264.35 565.27 244.54 575.8 264.35 599.8 264.35 584.63 283.82 599.8 302.5 575.12 302.05 564.37 320.61 553.39 301.71 530.63 301.25 543.65 281.78 530.63 264.35" />',
                '<polygon class="h" points="635.24 264.35 657.65 264.35 669.88 244.54 680.41 264.35 704.41 264.35 689.24 283.82 704.41 302.5 679.73 302.05 668.97 320.61 657.99 301.71 635.24 301.25 648.25 281.78 635.24 264.35" />',
                '<text class="i" transform="translate(175.67 467.04) rotate(-90) scale(1.14 1)">',
                str_ticket,
                '</text><text class="i" transform="translate(1011.14 467.04) rotate(-90) scale(1.14 1)">',
                str_ticket,
                "</text></svg>"
            )
        );
    }

    function constructTokenURI(SVGParams memory params)
        public
        pure
        returns (string memory)
    {
        string memory name = "GordoNFT ";
        string
            memory description = "Gordo NFT is offering an entirely new open and decentralized "
            "approach to the creation of jackpots and lottery tickets. Leveraging the power "
            "of blockchain technology, all transactions on the network are securely recorded "
            "on the public ledger and are always available to the players for review. Anyone "
            "in the network can view the Smart-Contract and view the sum. Winner, winner, chicken dinner!";
        string memory image = Base64.encode(bytes(generateSVG(params)));
        // status : winner , active, inactive
        string memory status = params.isWinner ? "Winner" : params.active
            ? "Active"
            : "Inactive";
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name,
                                uintToString(params.ticket),
                                '", "description":"',
                                description,
                                '", "image": "',
                                "data:image/svg+xml;base64,",
                                image,
                                '", "attributes": [{"trait_type": "Status", "value": "',
                                status,
                                '"}]}'
                            )
                        )
                    )
                )
            );
    }

    function uintToString(uint256 v) private pure returns (string memory str) {
        uint256 maxlength = 5;
        bytes memory s = new bytes(maxlength + 1);
        for (uint256 i = maxlength; i > 0; i--) {
            uint256 remainder = v % 10;
            v = v / 10;
            s[i] = bytes1(uint8(48 + remainder));
        }
        s[0] = "#";
        str = string(s);
    }
}
